    graphviz_host=www.graphviz.org
    GRAPHVIZ_PUB_PATH=/data/pub/graphviz/development/    
    work=$HOME/tmp/gviz
    SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
    PKGS=$GRAPHVIZ_PUB_PATH/macos/lion
    cd $work
    # get the sources
    scp gviz@$graphviz_host:$SOURCES/$source.tar.gz . 2>$LOG
    # build the package
    tar xzf $source.tar.gz
    (cd $source/macosx/build; cp Makefile.lion Makefile)
    make -C $source/macosx/build >>$LOG 2>&1
    # put the package
    scp $source/macosx/build/graphviz.pkg gviz@$graphviz_host:$PKGS/$source.pkg 2>>$LOG
    scp $LOG gviz@$graphviz_host:$PKGS/$LOG

