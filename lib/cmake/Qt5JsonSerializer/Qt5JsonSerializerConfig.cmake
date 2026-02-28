if (CMAKE_VERSION VERSION_LESS 3.1.0)
    message(FATAL_ERROR "Qt 5 JsonSerializer module requires at least CMake version 3.1.0")
endif()

get_filename_component(_qt5JsonSerializer_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

# For backwards compatibility only. Use Qt5JsonSerializer_VERSION instead.
set(Qt5JsonSerializer_VERSION_STRING 4.0.3)

set(Qt5JsonSerializer_LIBRARIES Qt5::JsonSerializer)

macro(_qt5_JsonSerializer_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::JsonSerializer\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
endmacro()


macro(_populate_JsonSerializer_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION
      IsDebugAndRelease)
    set_property(TARGET Qt5::JsonSerializer APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5JsonSerializer_install_prefix}/bin/${LIB_LOCATION}")
    _qt5_JsonSerializer_check_file_exists(${imported_location})
    set(_deps
        ${_Qt5JsonSerializer_LIB_DEPENDENCIES}
    )
    set(_static_deps
    )

    set_target_properties(Qt5::JsonSerializer PROPERTIES
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_deps};${_static_deps}"
    )
    set_property(TARGET Qt5::JsonSerializer APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 "${_deps}"
    )


    set(imported_implib "${_qt5JsonSerializer_install_prefix}/lib/${IMPLIB_LOCATION}")
    _qt5_JsonSerializer_check_file_exists(${imported_implib})
    if(NOT "${IMPLIB_LOCATION}" STREQUAL "")
        set_target_properties(Qt5::JsonSerializer PROPERTIES
        "IMPORTED_IMPLIB_${Configuration}" ${imported_implib}
        )
    endif()
endmacro()

if (NOT TARGET Qt5::JsonSerializer)

    set(_Qt5JsonSerializer_OWN_INCLUDE_DIRS "${_qt5JsonSerializer_install_prefix}/include/" "${_qt5JsonSerializer_install_prefix}/include/QtJsonSerializer")
    set(Qt5JsonSerializer_PRIVATE_INCLUDE_DIRS
        "${_qt5JsonSerializer_install_prefix}/include/QtJsonSerializer/4.0.3"
        "${_qt5JsonSerializer_install_prefix}/include/QtJsonSerializer/4.0.3/QtJsonSerializer"
    )

    foreach(_dir ${_Qt5JsonSerializer_OWN_INCLUDE_DIRS})
        _qt5_JsonSerializer_check_file_exists(${_dir})
    endforeach()

    # Only check existence of private includes if the Private component is
    # specified.
    list(FIND Qt5JsonSerializer_FIND_COMPONENTS Private _check_private)
    if (NOT _check_private STREQUAL -1)
        foreach(_dir ${Qt5JsonSerializer_PRIVATE_INCLUDE_DIRS})
            _qt5_JsonSerializer_check_file_exists(${_dir})
        endforeach()
    endif()

    set(Qt5JsonSerializer_INCLUDE_DIRS ${_Qt5JsonSerializer_OWN_INCLUDE_DIRS})

    set(Qt5JsonSerializer_DEFINITIONS -DQT_JSONSERIALIZER_LIB)
    set(Qt5JsonSerializer_COMPILE_DEFINITIONS QT_JSONSERIALIZER_LIB)
    set(_Qt5JsonSerializer_MODULE_DEPENDENCIES "Core")


    set(Qt5JsonSerializer_OWN_PRIVATE_INCLUDE_DIRS ${Qt5JsonSerializer_PRIVATE_INCLUDE_DIRS})

    set(_Qt5JsonSerializer_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5JsonSerializer_FIND_REQUIRED)
        set(_Qt5JsonSerializer_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5JsonSerializer_FIND_DEPENDENCIES_QUIET)
    if (Qt5JsonSerializer_FIND_QUIETLY)
        set(_Qt5JsonSerializer_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5JsonSerializer_FIND_VERSION_EXACT)
    if (Qt5JsonSerializer_FIND_VERSION_EXACT)
        set(_Qt5JsonSerializer_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5JsonSerializer_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5JsonSerializer_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                4.0.3 ${_Qt5JsonSerializer_FIND_VERSION_EXACT}
                ${_Qt5JsonSerializer_DEPENDENCIES_FIND_QUIET}
                ${_Qt5JsonSerializer_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5JsonSerializer_FOUND False)
            return()
        endif()

        list(APPEND Qt5JsonSerializer_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5JsonSerializer_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5JsonSerializer_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5JsonSerializer_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5JsonSerializer_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5JsonSerializer_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5JsonSerializer_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5JsonSerializer_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5JsonSerializer_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5JsonSerializer_EXECUTABLE_COMPILE_FLAGS)

    # It can happen that the same FooConfig.cmake file is included when calling find_package()
    # on some Qt component. An example of that is when using a Qt static build with auto inclusion
    # of plugins:
    #
    # Qt5WidgetsConfig.cmake -> Qt5GuiConfig.cmake -> Qt5Gui_QSvgIconPlugin.cmake ->
    # Qt5SvgConfig.cmake -> Qt5WidgetsConfig.cmake ->
    # finish processing of second Qt5WidgetsConfig.cmake ->
    # return to first Qt5WidgetsConfig.cmake ->
    # add_library cannot create imported target Qt5::Widgets.
    #
    # Make sure to return early in the original Config inclusion, because the target has already
    # been defined as part of the second inclusion.
    if(TARGET Qt5::JsonSerializer)
        return()
    endif()

    set(_Qt5JsonSerializer_LIB_DEPENDENCIES "Qt5::Core")


    add_library(Qt5::JsonSerializer SHARED IMPORTED)


    set_property(TARGET Qt5::JsonSerializer PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5JsonSerializer_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::JsonSerializer PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_JSONSERIALIZER_LIB)

    set_property(TARGET Qt5::JsonSerializer PROPERTY INTERFACE_QT_ENABLED_FEATURES )
    set_property(TARGET Qt5::JsonSerializer PROPERTY INTERFACE_QT_DISABLED_FEATURES )

    # Qt 6 forward compatible properties.
    set_property(TARGET Qt5::JsonSerializer
                 PROPERTY QT_ENABLED_PUBLIC_FEATURES
                 )
    set_property(TARGET Qt5::JsonSerializer
                 PROPERTY QT_DISABLED_PUBLIC_FEATURES
                 )
    set_property(TARGET Qt5::JsonSerializer
                 PROPERTY QT_ENABLED_PRIVATE_FEATURES
                 )
    set_property(TARGET Qt5::JsonSerializer
                 PROPERTY QT_DISABLED_PRIVATE_FEATURES
                 )

    set_property(TARGET Qt5::JsonSerializer PROPERTY INTERFACE_QT_PLUGIN_TYPES "")

    set(_Qt5JsonSerializer_PRIVATE_DIRS_EXIST TRUE)
    foreach (_Qt5JsonSerializer_PRIVATE_DIR ${Qt5JsonSerializer_OWN_PRIVATE_INCLUDE_DIRS})
        if (NOT EXISTS ${_Qt5JsonSerializer_PRIVATE_DIR})
            set(_Qt5JsonSerializer_PRIVATE_DIRS_EXIST FALSE)
        endif()
    endforeach()

    if (_Qt5JsonSerializer_PRIVATE_DIRS_EXIST)
        add_library(Qt5::JsonSerializerPrivate INTERFACE IMPORTED)
        set_property(TARGET Qt5::JsonSerializerPrivate PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${Qt5JsonSerializer_OWN_PRIVATE_INCLUDE_DIRS}
        )
        set(_Qt5JsonSerializer_PRIVATEDEPS)
        foreach(dep ${_Qt5JsonSerializer_LIB_DEPENDENCIES})
            if (TARGET ${dep}Private)
                list(APPEND _Qt5JsonSerializer_PRIVATEDEPS ${dep}Private)
            endif()
        endforeach()
        set_property(TARGET Qt5::JsonSerializerPrivate PROPERTY
            INTERFACE_LINK_LIBRARIES Qt5::JsonSerializer ${_Qt5JsonSerializer_PRIVATEDEPS}
        )

        # Add a versionless target, for compatibility with Qt6.
        if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND NOT TARGET Qt::JsonSerializerPrivate)
            add_library(Qt::JsonSerializerPrivate INTERFACE IMPORTED)
            set_target_properties(Qt::JsonSerializerPrivate PROPERTIES
                INTERFACE_LINK_LIBRARIES "Qt5::JsonSerializerPrivate"
            )
        endif()
    endif()

    _populate_JsonSerializer_target_properties(RELEASE "Qt5JsonSerializer.dll" "libQt5JsonSerializer.a" FALSE)

    if (EXISTS
        "${_qt5JsonSerializer_install_prefix}/bin/Qt5JsonSerializer.dll"
      AND EXISTS
        "${_qt5JsonSerializer_install_prefix}/lib/libQt5JsonSerializer.a" )
        _populate_JsonSerializer_target_properties(DEBUG "Qt5JsonSerializer.dll" "libQt5JsonSerializer.a" FALSE)
    endif()



    # In Qt 5.15 the glob pattern was relaxed to also catch plugins not literally named Plugin.
    # Define QT5_STRICT_PLUGIN_GLOB or ModuleName_STRICT_PLUGIN_GLOB to revert to old behavior.
    if (QT5_STRICT_PLUGIN_GLOB OR Qt5JsonSerializer_STRICT_PLUGIN_GLOB)
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5JsonSerializer_*Plugin.cmake")
    else()
        file(GLOB pluginTargets "${CMAKE_CURRENT_LIST_DIR}/Qt5JsonSerializer_*.cmake")
    endif()

    macro(_populate_JsonSerializer_plugin_properties Plugin Configuration PLUGIN_LOCATION
          IsDebugAndRelease)
        set_property(TARGET Qt5::${Plugin} APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

        set(imported_location "${_qt5JsonSerializer_install_prefix}/plugins/${PLUGIN_LOCATION}")
        _qt5_JsonSerializer_check_file_exists(${imported_location})
        set_target_properties(Qt5::${Plugin} PROPERTIES
            "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        )

    endmacro()

    if (pluginTargets)
        foreach(pluginTarget ${pluginTargets})
            include(${pluginTarget})
        endforeach()
    endif()



    _qt5_JsonSerializer_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5JsonSerializerConfigVersion.cmake")
endif()

# Add a versionless target, for compatibility with Qt6.
if(NOT "${QT_NO_CREATE_VERSIONLESS_TARGETS}" AND TARGET Qt5::JsonSerializer AND NOT TARGET Qt::JsonSerializer)
    add_library(Qt::JsonSerializer INTERFACE IMPORTED)
    set_target_properties(Qt::JsonSerializer PROPERTIES
        INTERFACE_LINK_LIBRARIES "Qt5::JsonSerializer"
    )
endif()
