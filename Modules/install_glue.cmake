INSTALL(CODE "
IF(DEFINED ENV{CMAKE_INSTALL_DIR_VERSION})
	SET(CMAKE_INSTALL_DIR_VERSION \"\$ENV{CMAKE_INSTALL_DIR_VERSION}\")
ELSE()
	SET(CMAKE_INSTALL_DIR_VERSION \"${CMAKE_INSTALL_DIR_VERSION_DEFAULT}\")
ENDIF()
")

