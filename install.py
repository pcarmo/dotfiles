from overrides import overrides 
import sys
import shutil
import os
import subprocess
from pathlib import Path


def is_tmux_installed():
    try:
        # Run 'tmux --version' to check if tmux is installed
        result = subprocess.run(['tmux', '--version'], check=True, text=True, capture_output=True)
        print("tmux is installed:", result.stdout.strip())
        return True
    except subprocess.CalledProcessError:
        print("tmux is not installed or an error occurred while trying to check.")
        return False
    except FileNotFoundError:
        print("tmux is not installed.")
        return False

class Setup:
    tmux_target_path: Path
    nvim_source_os: Path
    nvim_source_common: Path
    nvim_config_folder: Path
    def __init__(self):
        self.filename = '.tmux.conf'
        self.tmux_source = Path.cwd().joinpath("tmux").joinpath(self.filename)
        self.nvim_source = Path.cwd().joinpath("nvim")
        self.nvim_source_common = self.nvim_source.joinpath("common")

    def install_tmux(self):
        pass

class Dependencies:
    def __init__(self, setup: Setup, force: bool):
        self.setup = setup
        self.force = force

    def setup_tmux(self):
        print("Setting up tmux.")
        target = self.setup.tmux_target_path
        if(target.exists()):
            if(self.force):
                try:
                    os.rmdir(target)
                except OSError as e:
                    print("Error:" , e)
            else:
                print("Failed to update {}, it already exists".format(target))
        print("Creating file ", target)
        print("and linking to ", self.setup.tmux_source)
        shutil.copy2(self.setup.tmux_source, target)
        if(not is_tmux_installed()):
            self.setup.install_tmux()
        result = subprocess.run(['tmux', 'source', str(target)], check=True, text=True, capture_output=True)
        print(result.stdout)
    def setup_nvim(self):
        print("Setting up nvim.")
        nvim_source_os = self.setup.nvim_source_os
        nvim_source_common = self.setup.nvim_source_common
        
        if(os.path.isdir(nvim_source_common)):
            print("Found: ", nvim_source_common)
            config = self.setup.nvim_config_folder
            if(os.path.isdir(config)):
                print("{} already exists".format(config))
                if(not self.force):
                    print("Failed to update {}, it already exists. If you really wish to update, force it.".format(config))
                else:
                    print("Force enabled, removing {}".format(config))
                    shutil.rmtree(config)
            else:
                config.mkdir(parents = True, exist_ok=True)
            print("copying {0} to {1}".format(nvim_source_common, config))
            shutil.copytree(nvim_source_common, config, dirs_exist_ok=True)
        else:
            print("Unable to find: ", nvim_source_common)
            return

        if(not os.path.isdir(nvim_source_os)):
            print("Unable to find: ", nvim_source_os)
            return
        print("Found: ", nvim_source_os)
        #TODO: Solve when needed
        #shutil.copytree(nvim_source_common, config)
        print("Neovim config done at: ", config)



class MacOsSetup(Setup):
    def __init__(self):
        super().__init__()
        self.tmux_target_path = Path.home().joinpath(self.filename)
        self.nvim_source_os = self.nvim_source.joinpath("macos")
        self.nvim_config_folder = Path.home().joinpath(".config").joinpath("nvim")
        pass
    @overrides
    def install_tmux(self):
        try:
            print("Installing tmux...")
            subprocess.run(['brew', 'install', 'tmux'], check=True)
            print("tmux installed successfully.")
        except subprocess.CalledProcessError as e:
            print("Failed to install tmux:", str(e))

if __name__ == "__main__":
    dep: Dependencies = Dependencies(MacOsSetup(), False)
    if sys.platform == "linux" or sys.platform == "linux2":
        # Linux specific code
        print("Detected linux.")
    elif sys.platform == "darwin":
        # macOS specific code
        print("Detected macos.")
        dep = Dependencies(MacOsSetup(), True)
    elif sys.platform == "win32":
        # Windows specific code
        print("Detected Windows")
    
    dep.setup_tmux()
    dep.setup_nvim()
    


