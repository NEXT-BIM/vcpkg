if(NOT COMMAND z_vcpkg_@PORT@_get_link_libraries)
    function(z_vcpkg_@PORT@_get_link_libraries out_var type libraries)
        set(libs "")
        if(type STREQUAL "DEBUG")
            set(vcpkg_link_directories "${z_vcpkg_@PORT@_root}/debug/lib" "${z_vcpkg_@PORT@_root}/lib")
        else()
            set(vcpkg_link_directories "${z_vcpkg_@PORT@_root}/lib" "${z_vcpkg_@PORT@_root}/debug/lib")
        endif()
        foreach(lib IN LISTS libraries)
            if(lib MATCHES [[^/|^(dl|m|pthread)$|^-framework ]])
                list(APPEND libs "${lib}")
            elseif(EXISTS "${lib}")
                list(APPEND libs "${lib}")
            else()
                string(MAKE_C_IDENTIFIER "${out_var}_${lib}_${type}" lib_var)
                find_library("${lib_var}" NAMES "${lib}" NAMES_PER_DIR PATHS ${vcpkg_link_directories})
                mark_as_advanced("${lib_var}")
                if(${lib_var})
                    list(APPEND libs "${${lib_var}}")
                else()
                    find_library("${lib_var}" NAMES "${lib}" NAMES_PER_DIR PATHS ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES} NO_DEFAULT_PATH)
                    if(${lib_var})
                        list(APPEND libs "${lib}")
                    else()
                        message(WARNING "Omitting '${lib}' from link libraries.")
                    endif()
                endif()
            endif()
        endforeach()
        set("${out_var}" "${libs}" PARENT_SCOPE)
    endfunction()
endif()

get_filename_component(z_vcpkg_@PORT@_root "${CMAKE_CURRENT_LIST_DIR}" PATH)
get_filename_component(z_vcpkg_@PORT@_root "${z_vcpkg_@PORT@_root}" PATH)

file(GLOB z_vcpkg_@PORT@_config_files "${CMAKE_CURRENT_LIST_DIR}/unofficial-@PORT@-*-targets.cmake")
foreach(z_vcpkg_@PORT@_config_file IN LISTS z_vcpkg_@PORT@_config_files)
    include("${z_vcpkg_@PORT@_config_file}")
endforeach()

unset(z_vcpkg_@PORT@_config_file)
unset(z_vcpkg_@PORT@_config_files)
unset(z_vcpkg_@PORT@_root)
