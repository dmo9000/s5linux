for PKG in `ls -1 ./spool/*.pkg` ; do 
	FILENAME=`basename ${PKG}`
	ZFILENAME=${FILENAME}.gz
	if [ "spool/${FILENAME}" -nt "spool/${ZFILENAME}" ] || [ ! -r "spool/${ZFILENAME}" ]; then
		echo "Compressing package ${FILENAME} to ${ZFILENAME} ..."
		#gzip -f -9 -k "spool/${FILENAME}"
		pigz -f -9 -k "spool/${FILENAME}"
		touch "spool/${FILENAME}"
		fi
	sudo cp "spool/${ZFILENAME}" install-root/packages/"${ZFILENAME}"
	done

