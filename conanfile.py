from conans import ConanFile, CMake, tools
import os

class TemplateRepo(ConanFile):
    name = "cross-cov-gtest"
    version = "0.0.1"
    url = "https://github.com/channgo2203/cross-cov-gtest"
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake", "ycm"
    exports_sources = 'CMakeLists.txt', 'cmake/*', 'src/*', 'include/*'
    # Fill in with your gtest conan package
    build_requires = (
        "gtest/1.8.1@av/stable",
    )

    options = {
        "fPIC": [True, False],
        "shared": [True, False],
        "build_tests": [True, False],
    }

    default_options = {
        "fPIC":True,
        "shared" : True,
        "build_tests" : True
    }

    def build(self):
        cmake = CMake(self)
        cmake.definitions["CONAN_AUTO_INSTALL"] = False
        cmake.definitions["USE_CLANG_TIDY"] = False
        cmake.definitions["BUILD_SHARED_LIBS"] = self.options.shared
        cmake.definitions["USE_CPPCHECK"] = True
        cmake.configure()
        cmake.build(args=["--", "-j%s" % tools.cpu_count()])

    def package(self):
        cmake = CMake(self)
        cmake.install()
        # Install executable
        self.copy("bin/*")
        # Install config
        self.copy("config/*")
        # Install libraries
        self.copy("lib/*")

    def package_info(self):
        self.cpp_info.includedirs = ["include"]
        self.cpp_info.libs = tools.collect_libs(self)
        self.cpp_info.libdirs = ["lib"]
        self.cpp_info.bindirs = ["bin"]
        self.env_info.LD_LIBRARY_PATH.append(
            os.path.join(self.package_folder, "lib"))
        self.env_info.PATH.append(os.path.join(self.package_folder, "bin"))
        for libpath in self.deps_cpp_info.lib_paths:
            self.env_info.LD_LIBRARY_PATH.append(libpath)

    def imports(self):
        import_dir = os.getenv("CONAN_IMPORT_PATH", ".")
        bin_dir = os.path.join(import_dir, "bin")
        config_dir = os.path.join(import_dir, "config")
        lib_dir = os.path.join(import_dir, "lib")
        # Copy from external libraries
        self.copy("*.a*", dst=lib_dir, src="lib/", keep_path=False)
        self.copy("*.so*", dst=lib_dir, src="lib/", keep_path=False)
        self.copy("*.so*", dst=lib_dir, src="lib64/", keep_path=False)
        self.copy("*.xml*", dst=lib_dir, src="lib/", keep_path=False)
        # Copy from aptivware-core package
        self.copy("*", dst=bin_dir, src="bin/", root_package="aptivware-core", keep_path=False)
        self.copy("*", dst=lib_dir, src="lib/", root_package="aptivware-core", keep_path=True)
