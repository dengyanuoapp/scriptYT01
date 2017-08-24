#!/bin/sh

AV=Ao
year=2016
pass01='xxxYY'

if [ ! -f a10.txt ]
then
    echo
    echo
    echo "a10.txt don't exist . should be copy from /scriptYT01/aoaoao.txt . exit. "
    echo "you should copy /scriptYT01/a21.sh to /tmp/ , modify it and run it."
    echo
    exit
fi

echo '#!/bin/sh' > a15.txt
for a21 in \
    1 \
    2 \
    3 \
    4 \
    5 \
    6 \
    7 \
    8 \
    9 \
    10 \
    11 \
    12 \

do
    a22=$(printf "%02d" ${a21})
    rm -fr ${a21}
    mkdir ${a21}
    (
        cd ${a21}
        cat ../a10.txt \
            | sed -e "s;Ao_201703;${AV}_${year}${a22};g" \
            > a11.txt 
        cat a11.txt  \
            sed -e 's;2 = 2;2 = 3;g'   \
            > a12.txt 
        sh ./a11.txt "${pass01}"
    )

    echo ''                         >> a15.txt
    echo '('                        >> a15.txt
    echo "cd ${a21}"                >> a15.txt
    echo "nohup sh ./a12.txt"       >> a15.txt
    echo "slee 2"                   >> a15.txt
    echo ')'                        >> a15.txt

done
