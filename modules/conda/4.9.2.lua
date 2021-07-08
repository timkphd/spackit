help([[
   Anaconda version 4.9.2, with base Python 3.9
]])

whatis("Anaconda Distribution 4.9.2")

local base = "/nopt/nrel/apps/anaconda"
local version = "mini_py39_4.9.2"
local asptp_string = [==[
    if [ -n "${_CE_CONDA}" ] && [ -n "${WINDIR+x}" ]; then
        SYSP=$(dirname "${CONDA_EXE}");
    else
        SYSP=$(dirname "${CONDA_EXE}");
        SYSP=$(dirname "${SYSP}");
    fi;
    if [ -n "${WINDIR+x}" ]; then
        PATH="${SYSP}/bin:${PATH}";
        PATH="${SYSP}/Scripts:${PATH}";
        PATH="${SYSP}/Library/bin:${PATH}";
        PATH="${SYSP}/Library/usr/bin:${PATH}";
        PATH="${SYSP}/Library/mingw-w64/bin:${PATH}";
        PATH="${SYSP}:${PATH}";
    else
        PATH="${SYSP}/bin:${PATH}";
    fi;
    export PATH
]==]

local conda_activate_string = [==[
    if [ -n "${CONDA_PS1_BACKUP:+x}" ]; then
        PS1="$CONDA_PS1_BACKUP";
        unset CONDA_PS1_BACKUP;
    fi;
    local cmd="$1";
    shift;
    local ask_conda;
    CONDA_INTERNAL_OLDPATH="${PATH}";
    __add_sys_prefix_to_path;
    ask_conda="$(PS1="$PS1" "$CONDA_EXE" $_CE_M $_CE_CONDA shell.posix "$cmd" "$@")" || return $?;
    rc=$?;
    PATH="${CONDA_INTERNAL_OLDPATH}";
    eval "$ask_conda";
    if [ $rc != 0 ]; then
        export PATH;
    fi;
    __conda_hashr
]==]

local conda_hashr_string = [==[
    if [ -n "${ZSH_VERSION:+x}" ]; then
        rehash;
    else
        if [ -n "${POSH_VERSION:+x}" ]; then
            :;
        else
            hash -r;
        fi;
    fi
]==]

local conda_reactivate_string = [==[
    local ask_conda;
    CONDA_INTERNAL_OLDPATH="${PATH}";
    __add_sys_prefix_to_path;
    ask_conda="$(PS1="$PS1" "$CONDA_EXE" $_CE_M $_CE_CONDA shell.posix reactivate)" || return $?;
    PATH="${CONDA_INTERNAL_OLDPATH}";
    eval "$ask_conda";
    __conda_hashr
]==]

--[[
local conda_string = [==[
    if [ "$#" -lt 1 ]; then
        "$CONDA_EXE" $_CE_M $_CE_CONDA;
    else
        \local cmd="$1";
        shift;
        case "$cmd" in 
            activate | deactivate)
                __conda_activate "$cmd" "$@"
            ;;
            install | update | upgrade | remove | uninstall)
                CONDA_INTERNAL_OLDPATH="${PATH}";
                __add_sys_prefix_to_path;
                "$CONDA_EXE" $_CE_M $_CE_CONDA "$cmd" "$@";
                \local t1=$?;
                PATH="${CONDA_INTERNAL_OLDPATH}";
                if [ $t1 = 0 ]; then
                    __conda_reactivate;
                else
                    return $t1;
                fi
            ;;
            *)
                CONDA_INTERNAL_OLDPATH="${PATH}";
                __add_sys_prefix_to_path;
                "$CONDA_EXE" $_CE_M $_CE_CONDA "$cmd" "$@";
                \local t1=$?;
                PATH="${CONDA_INTERNAL_OLDPATH}";
                return $t1
            ;;
        esac;
    fi
]==]
]]

local conda_string = [==[
    if [ "$#" -lt 1 ]; then
        "$CONDA_EXE" $_CE_M $_CE_CONDA;
    else
        local cmd="$1";
        shift;
        case "$cmd" in 
            activate | deactivate)
                __conda_activate "$cmd" "$@"
            ;;
            install | update | upgrade | remove | uninstall)
                CONDA_INTERNAL_OLDPATH="${PATH}";
                __add_sys_prefix_to_path;
                "$CONDA_EXE" $_CE_M $_CE_CONDA "$cmd" "$@";
                local t1=$?;
                PATH="${CONDA_INTERNAL_OLDPATH}";
                if [ $t1 = 0 ]; then
                    __conda_reactivate;
                else
                    return $t1;
                fi
            ;;
            *)
                CONDA_INTERNAL_OLDPATH="${PATH}";
                __add_sys_prefix_to_path;
                "$CONDA_EXE" $_CE_M $_CE_CONDA "$cmd" "$@";
                local t1=$?;
                PATH="${CONDA_INTERNAL_OLDPATH}";
                return $t1
            ;;
        esac;
    fi
]==]
set_shell_function("__add_sys_prefix_to_path", asptp_string)
set_shell_function("__conda_activate", conda_activate_string)
set_shell_function("__conda_hashr", conda_hashr_string)
set_shell_function("__conda_reactivate", conda_reactivate_string)
set_shell_function("conda", conda_string)
setenv("CONDA_EXE", pathJoin(base, version, "bin/conda"))
setenv("CONDA_PYTHON_EXE", pathJoin(base, version, "bin/python"))
setenv("CONDA_SHLVL","0")
setenv("CONDA_ENVS_PATH","~/.conda-envs")
setenv("CONDA_PKGS_DIRS","~/.conda-pkgs")
setenv("_CE_CONDA","")
setenv("_CE_M","")
setenv("REQUESTS_CA_BUNDLE","/etc/ssl/certs/ca-bundle.crt")
prepend_path("PATH", pathJoin(base, version, "condabin"))
prepend_path("PATH", pathJoin(base, version, "bin"))
prepend_path("MANPATH", pathJoin(base, version, "share/man"))

