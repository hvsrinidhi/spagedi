# Command for creating a package with defined name

INCLUDE(CPackConfig.cmake)

SET(PACKAGE_VERSION "${CPACK_PACKAGE_VERSION}")
SET(PACKAGE_NAME "${CPACK_PACKAGE_NAME}")

INCLUDE("${CMAKE_BINARY_DIR}/src/spagedi_version.h")

# Some files use directories that contain the version number
# Update as needed
IF(PACKAGE_VERSION MATCHES "([0-9]+)\\.([0-9]+)([a-z]+)-?(.*)")
	SET(ENV{CMAKE_INSTALL_DIR_VERSION} ${CMAKE_MATCH_1}.${CMAKE_MATCH_2})
ENDIF()

EXECUTE_PROCESS(COMMAND ${CMAKE_CPACK_COMMAND}
	-D NEW_PACKAGE=TRUE
	-D CPACK_PACKAGE_FILE_NAME=${PACKAGE_NAME}-${PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}
	--config CPackConfig.cmake
	-P "${PACKAGE_NAME}"
	-R "${PACKAGE_VERSION}"
	TIMEOUT 3600
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

