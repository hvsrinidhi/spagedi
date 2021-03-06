# Command for creating a package source with defined name

INCLUDE(CPackSourceConfig.cmake)

SET(PACKAGE_VERSION "${CPACK_PACKAGE_VERSION}")
SET(PACKAGE_NAME "${CPACK_PACKAGE_NAME}")

INCLUDE("${CMAKE_BINARY_DIR}/src/spagedi_version.h")

EXECUTE_PROCESS(COMMAND ${CMAKE_CPACK_COMMAND}
	-D NEW_PACKAGE=TRUE
	-D CPACK_PACKAGE_FILE_NAME=${PACKAGE_NAME}-${PACKAGE_VERSION}
	--config CPackSourceConfig.cmake
	-P "${PACKAGE_NAME}"
	-R "${PACKAGE_VERSION}"
	TIMEOUT 3600
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

