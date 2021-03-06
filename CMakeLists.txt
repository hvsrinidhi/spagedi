CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_BUILD_TYPE_INIT "RelWithDebInfo")
SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")

PROJECT(SPAGeDi)
SET(SPAGEDI_NAME "SPAGeDi")
SET(SPAGEDI_VERSION "1.4b-CUSTOM") # Default Version Number

# Automatic Version Numbers
FIND_PACKAGE(Git)

INCLUDE("${CMAKE_SOURCE_DIR}/src/spagedi_version.h.pkg" OPTIONAL
	RESULT_VARIABLE VERSION_FOUND)

IF(VERSION_FOUND)
	SET(SPAGEDI_VERSION "${PACKAGE_VERSION}")
ELSEIF(SPAGEDI_VERSION_GIT)
	SET(SPAGEDI_VERSION "${SPAGEDI_VERSION_GIT}")
ELSEIF(GIT_FOUND)
	EXECUTE_PROCESS(
	     COMMAND ${GIT_EXECUTABLE} describe --tags --dirty
	     RESULT_VARIABLE GIT_RESULT
	     OUTPUT_VARIABLE PKG_VERSION
	     OUTPUT_STRIP_TRAILING_WHITESPACE
	     ERROR_QUIET
	)
	IF(GIT_RESULT EQUAL 0)
		SET(SPAGEDI_VERSION "${PKG_VERSION}")
	ENDIF()
ENDIF()

IF(SPAGEDI_VERSION MATCHES "([0-9]+)\\.([0-9]+)([a-z]+)-?(.*)")
	SET(SPAGEDI_VERSION_MAJOR ${CMAKE_MATCH_1})
	SET(SPAGEDI_VERSION_MINOR ${CMAKE_MATCH_2})
	SET(SPAGEDI_VERSION_PATCH ${CMAKE_MATCH_3})
	SET(SPAGEDI_VERSION_BUILD ${CMAKE_MATCH_4})
	SET(SPAGEDI_VERSION_MAIN "${SPAGEDI_VERSION_MAJOR}.${SPAGEDI_VERSION_MINOR}${SPAGEDI_VERSION_PATCH}")
	
	SET(LETTERS a b c d e f g h i j k l m n o p q r s t u v w x y z)
	LIST(FIND LETTERS ${SPAGEDI_VERSION_PATCH} SPAGEDI_VERSION_PATCH_NUM)
	SET(SPAGEDI_VERSION_NUMBERED "${SPAGEDI_VERSION_MAJOR}.${SPAGEDI_VERSION_MINOR}.${SPAGEDI_VERSION_PATCH_NUM}.0")
ENDIF()

IF(WIN32 AND NOT UNIX)
  SET(SPAGEDI_DIR)
ELSEIF(APPLE_BUNDLE)
  SET(SPAGEDI_DIR)
ELSE(WIN32 AND NOT UNIX)
  SET(CMAKE_INSTALL_DIR_VERSION_DEFAULT "${SPAGEDI_VERSION_MAJOR}.${SPAGEDI_VERSION_MINOR}")
  SET(SPAGEDI_DIR "/spagedi-\${CMAKE_INSTALL_DIR_VERSION}")
ENDIF(WIN32 AND NOT UNIX)

SET(CMAKE_DATA_DIR "share${SPAGEDI_DIR}" CACHE STRING
  "Install location for data (relative to prefix).")
SET(CMAKE_DOC_DIR "doc${SPAGEDI_DIR}" CACHE STRING
  "Install location for documentation (relative to prefix).")
SET(CMAKE_MAN_DIR "man" CACHE STRING
  "Install location for man pages (relative to prefix).")
MARK_AS_ADVANCED(CMAKE_DATA_DIR CMAKE_DOC_DIR CMAKE_MAN_DIR)

SET(CPACK_SOURCE_IGNORE_FILES
  "/CVS/" /\\\\\\\\.bzr/;/\\\\\\\\.hg/;/\\\\\\\\.git/;\\\\\\\\.swp$;\\\\\\\\.#;/#"
  "/CVS/" "/\\\\.svn/" "/\\\\.bzr/" "/\\\\.hg/" "/\\\\.git/"  "\\\\.swp$"
  "\\\\.#"  "/#"  ".*~$"
  "/releng/" "/build/"
  "spagedi\\\\.exe"  "spagedi$"
  "/CMakeFiles/"  "CMakeCache\\\\.txt"
  "CPack.*Config\\\\.cmake"  "cmake_install\\\\.cmake"
  "install_manifest\\\\.txt$"
  "_CPACK_PACKAGES"  "_CPack_Packages"
  "\\\\.vcproj"  "\\\\.dir"  "\\\\.ncb$"  "\\\\.sln$"  "\\\\.suo$"
  "Makefile$" "\\\\.ilk"  "\\\\.pdb"
)

SET(CPACK_INSTALL_SCRIPT "${CMAKE_SOURCE_DIR}/Modules/new_install.cmake")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY "${SPAGEDI_NAME}")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Spatial Pattern Analysis of Genetic Diversity")
SET(CPACK_PACKAGE_VERSION ${SPAGEDI_VERSION})
SET(CPACK_PACKAGE_VERSION_MAJOR ${SPAGEDI_VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${SPAGEDI_VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${SPAGEDI_VERSION_PATCH})
SET(CPACK_PACKAGE_VENDOR "OlivierHardy")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/readme.txt")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/copying.txt")
SET(CPACK_PACKAGE_EXECUTABLES "spagedi" "SPAGeDi")

SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")

IF(NOT DEFINED CPACK_SYSTEM_NAME)
	if(APPLE) # work around a bug in CMakeDetermineSystem.cmake
		exec_program(uname ARGS -m OUTPUT_VARIABLE CPACK_SYSTEM_PROCESSOR RETURN_VAL val)
		IF("${CMAKE_C_FLAGS}" MATCHES "[-]m32")
			SET(CPACK_SYSTEM_PROCESSOR i386)
		ELSEIF("${CMAKE_C_FLAGS}" MATCHES "[-]m64")
			SET(CPACK_SYSTEM_PROCESSOR x86_64)
		ENDIF()
		if(CPACK_SYSTEM_PROCESSOR STREQUAL "x86_64")
			set(CPACK_SYSTEM_NAME Darwin64)
		else()
			set(CPACK_SYSTEM_NAME Darwin)
		endif()
		SET(CPACK_SYSTEM_NAME ${CPACK_SYSTEM_NAME}-${CPACK_SYSTEM_PROCESSOR})
	elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "CYGWIN")
		SET(CPACK_SYSTEM_NAME Cygwin-x86)
	elseif(UNIX)
		set(CPACK_SYSTEM_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR})
		# Check for building 32-bit binaries on 64-bit machines
		# Adjust names as appropriate
		IF("${CMAKE_C_FLAGS}" MATCHES "[-]m32")
			IF(CPACK_SYSTEM_PROCESSOR MATCHES "x86")
				SET(CPACK_SYSTEM_PROCESSOR x86_32)
			ELSE()
				SET(CPACK_SYSTEM_PROCESSOR i386)
			ENDIF()
		# Check for building 64-bit binaries on 32-bit machines
		# Adjust names as appropriate
		ELSEIF("${CMAKE_C_FLAGS}" MATCHES "[-]m64")
			IF(CPACK_SYSTEM_PROCESSOR MATCHES "x86")
				SET(CPACK_SYSTEM_PROCESSOR x86_64)
			ELSE()
				SET(CPACK_SYSTEM_PROCESSOR amd64)
			ENDIF()
		ENDIF()
		SET(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CPACK_SYSTEM_PROCESSOR})
	ELSE()
		SET(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})
	ENDIF()
ENDIF()

IF(${CPACK_SYSTEM_NAME} MATCHES Windows)
  IF(CMAKE_CL_64)
    SET(CPACK_SYSTEM_NAME Win64-amd64)
	SET(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
  ELSE()
    SET(CPACK_SYSTEM_NAME Win32-x86)
  ENDIF()
ENDIF()

IF(NOT DEFINED CPACK_PACKAGE_FILE_NAME)
    SET(CPACK_PACKAGE_FILE_NAME 
      "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
ENDIF()

IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  #SET(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/Utilities/Release\\\\InstallIcon.bmp")
  SET(CPACK_SOURCE_GENERATOR "ZIP")
  SET(CPACK_GENERATOR "ZIP;NSIS")
  SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\spagedi.exe")
  SET(CPACK_NSIS_DISPLAY_NAME "${SPAGEDI_NAME} ${SPAGEDI_VERSION_MAIN}")
  SET(CPACK_NSIS_HELP_LINK "http:\\\\\\\\www.ulb.ac.be\\\\sciences\\\\ecoevol\\\\spagedi.html")
  SET(CPACK_NSIS_URL_INFO_ABOUT "http:\\\\\\\\www.ulb.ac.be\\\\sciences\\\\ecoevol\\\\spagedi.html")
  SET(CPACK_NSIS_CONTACT "ohardy@ulb.ac.be")
  SET(CPACK_NSIS_MODIFY_PATH ON)
  SET(CPACK_NSIS_DEFINES "
		VIProductVersion ${SPAGEDI_VERSION_NUMBERED}
		VIAddVersionKey ProductName \\\"${SPAGEDI_NAME}\\\"
		VIAddVersionKey FileDescription \\\"Spatial Pattern Analysis of Genetic Diversity\\\"
		VIAddVersionKey Comments \\\"A binary installer for ${SPAGEDI_NAME}.\\\"
		VIAddVersionKey CompanyName \\\"${CPACK_PACKAGE_VENDOR}\\\"
		VIAddVersionKey LegalCopyright \\\"${CPACK_PACKAGE_VENDOR}\\\"
		VIAddVersionKey InternalName \\\"${SPAGEDI_NAME} Installer\\\"
		VIAddVersionKey LegalTrademarks \\\"\\\"
		VIAddVersionKey OriginalFilename \\\"${CPACK_PACKAGE_FILE_NAME}.exe\\\"
		VIAddVersionKey FileVersion ${SPAGEDI_VERSION_NUMBERED}
		VIAddVersionKey ProductVersion ${SPAGEDI_VERSION_NUMBERED}
	")
ELSEIF(APPLE)
  SET(CPACK_SOURCE_GENERATOR "TBZ2") 
  SET(CPACK_GENERATOR "PackageMaker" "TBZ2")
  SET(CPACK_STRIP_FILES "bin/spagedi")  
ELSE()
  SET(CPACK_SOURCE_GENERATOR "TBZ2") 
  SET(CPACK_GENERATOR "TBZ2")
  SET(CPACK_STRIP_FILES "bin/spagedi")
ENDIF()

SET(CPACK_SOURCE_DIR ${CMAKE_SOURCE_DIR})
SET(CPACK_BINARY_DIR ${CMAKE_BINARY_DIR})
INCLUDE(CPack)

ADD_CUSTOM_TARGET(version
    ${CMAKE_COMMAND} -D SRC=${CMAKE_SOURCE_DIR}
                     -D DST=${CMAKE_BINARY_DIR}
                     -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
                     -D PACKAGE_NAME=${SPAGEDI_NAME}
                     -D PACKAGE_VERSION=${SPAGEDI_VERSION}
                     -P ${CMAKE_SOURCE_DIR}/Modules/version.cmake
)

ADD_CUSTOM_TARGET(new_package
	COMMAND ${CMAKE_COMMAND} 
		-P ${CMAKE_SOURCE_DIR}/Modules/new_package.cmake
)

ADD_CUSTOM_TARGET(new_package_source
	COMMAND ${CMAKE_COMMAND} 
		-P ${CMAKE_SOURCE_DIR}/Modules/new_package_source.cmake
)

ADD_DEPENDENCIES(new_package version spagedi)
ADD_DEPENDENCIES(new_package_source version)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(example_data)

INCLUDE(install_glue)

INSTALL(FILES manual.pdf copying.txt readme.txt DESTINATION ${CMAKE_DOC_DIR})

#INCLUDE(InstallRequiredSystemLibraries)

