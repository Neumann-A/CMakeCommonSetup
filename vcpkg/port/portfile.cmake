vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Neumann-A/CMakeCommonSetup
    REF b9b25da543145166b01bcca01c3cbedfcbd06307 # v2.1.1
    SHA512 f1de563bf811c285447fdf8e88e4861f1ac0e10bf830cedec587b7a85dcfb2fc9b038dd1f71cbbbf4774c517b5097f3c4afad5048b6a3dfd21f8f0e23ab67ec1
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    #OPTIONS
)
vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/${PORT})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
