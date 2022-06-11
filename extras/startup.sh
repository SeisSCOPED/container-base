if [ $# -eq 0 ]; then
    NOTEBOOK_ARGS="--no-browser --ip=0.0.0.0 --allow-root"
    jupyter lab ${NOTEBOOK_ARGS}
else
    exec $@
fi
