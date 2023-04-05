import os

from conans import ConanFile, CMake, tools


class HelloTestConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = {"pkg_config", "PkgConfigDeps", "cmake"}
    requires = ["gtest/cci.20210126"]
    options = {
        "coverage": [True, False]}
    default_options = {"coverage": False}

    def imports(self):
        self.copy("*.gcno", dst="bin", src="lib")

    def build(self):
        self.cmake = CMake(self)
        self.cmake.configure()
        self.cmake.build()

    def test(self):
        self.cmake.parallel = False
        if self.options.coverage:
            self.cmake.build(target="cov")
        else:
            self.cmake.test()

