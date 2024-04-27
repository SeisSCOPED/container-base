if [ $# -eq 0 ]; then

    ## Creating reverse tunnel port to login nodes
    NODE_HOSTNAME=`hostname -s` > /dev/null 2>&1
    LOGIN_PORT=`echo $NODE_HOSTNAME | perl -ne 'print (($2+1).$3.$1) if /c\d(\d\d)-(\d)(\d\d)/;'` > /dev/null 2>&1
    STATUS_PORT=$(($LOGIN_PORT + 1))
    TERM='xterm-256color'
    echo "got login node port $LOGIN_PORT"
    echo "got status node port $STATUS_PORT"
    # create reverse tunnel port to login nodes.  Make one tunnel for each login so the user can just
    # connect to stampede.tacc
    for i in `seq 4`; do
        ssh -q -f -g -N -R $LOGIN_PORT:$NODE_HOSTNAME:8888 login$i > /dev/null 2>&1
        ssh -q -f -g -N -R $STATUS_PORT:$NODE_HOSTNAME:8787 login$i > /dev/null 2>&1
    done
    # creating notebook password, giving link
    JUPYTER_PWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)
    echo "Created reverse ports on Stampede2 logins"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "Welcome to SCOPED Tapis interactive" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols); echo -e "\n"
    echo  "The Link below will open a Jupyter Notebook for the $_tapisAppId app" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols); echo -e "\n"
    echo "http://frontera.tacc.utexas.edu:$LOGIN_PORT/lab?token=$JUPYTER_PWD" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols); echo -e "\n"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - |  head -c $(tput cols);echo -e "\n"

    NOTEBOOK_ARGS=" --notebook-dir=${WORKDIR} --port=${JUPYTER_PORT} --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token=${JUPYTER_PWD}"
    jupyter lab ${NOTEBOOK_ARGS}
else
    exec $@
fi
