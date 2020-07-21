goeko@elefisch:~/Temp/Brians_Phone_Photos/Camera$ 
for f in * 
do 
  if test ! -f /network/Personal/Digital_Pictures/Brians_Cell_Phone/DCIM/Camera/$f ; then
    echo "no file /network/Personal/Digital_Pictures/Brians_Cell_Phone/DCIM/Camera/$f"
  else
    echo "file $f found"
  fi
done

goeko@elefisch:~/Temp/Brians_Phone_Photos/Camera$
for f in * 
do
  if test ! -f /network/Personal/Digital_Pictures/Brians_Cell_Phone/DCIM/Camera/$f ;then
    echo "no file /network/Personal/Digital_Pictures/Brians_Cell_Phone/DCIM/Camera/$f"
    cp "${f}" "/network/Personal/Digital_Pictures/Brians_Cell_Phone/DCIM/Camera/$f" 
    echo "file copied" 
  else 
    echo "file $f found"
  fi
done 

| grep -i "no file"
