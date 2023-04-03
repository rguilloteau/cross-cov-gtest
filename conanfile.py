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
        "gtest/cci.20210126",
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