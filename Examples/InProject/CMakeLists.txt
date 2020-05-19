cmake_minimum_required (VERSION 3.17)
include(../../cmake/CMakeCS.cmake)

project(CMakeCS_InProject 
        VERSION 0.1.0 
        DESCRIPTION "Test CMakeCS droped into the project"
        HOMEPAGE_URL "https://github.com/Neumann-A/CMakeCommonSetup"
        LANGUAGES CXX
        )
cmcs_init_project( PACKAGE_NAME CMCS_IP
                   REQUIRED_PACKAGES GTest Benchmark
                   OPTIONAL_PACKAGES Eigen3 boost
                   boost_COMPONENTS program_options random
                   OPTIONAL_CONDITIONAL_PACKAGES cpp_taskflow
                   cpp_taskflow_CONDITIONAL "TARGET boost::random;TARGET boost::program_options"
)

cmcs_finalize_project()
feature_summary(WHAT ALL)
