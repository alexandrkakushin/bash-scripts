#!/bin/bash
# Скрипт для создания виртуальной машины

echo "Create VirtualBox VM...\n" 

echo -n "Name VM: " 
	read VM
echo -n "Type OS: " 
	read OSTYPE
echo -n "RAM (Мб): " 
	read RAMSIZE		
echo -n "Size HDD (Мб): " 
	read HDDSIZE	
echo -n "Boot CD/DVD ISO: " 
	read MEDIUM
echo -n "RDP port: " 
	read VRDEPORT


BASEFOLDER="$(pwd)"
echo "\nBASE FOLDER: ${BASEFOLDER}"

echo "\nCREATE VM"
vboxmanage createvm --name $VM --ostype $OSTYPE --register --basefolder ${BASEFOLDER}

if [ ! -e ${VM} ]
then
  mkdir ${VM} 
fi
cd ${VM}

echo "CREATE HDD"
vboxmanage createmedium --filename $VM.vdi --size ${HDDSIZE}

echo "ADD SATA AND IDE CONTROLLERS"
vboxmanage storagectl $VM --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi 

vboxmanage storagectl $VM --name "IDE Controller" --add ide --controller PIIX4

echo "MODIFY VM"
vboxmanage modifyvm $VM --memory ${RAMSIZE} 
vboxmanage modifyvm $VM --acpi on
vboxmanage modifyvm $VM --boot1 dvd
vboxmanage modifyvm $VM --nic1 bridged --bridgeadapter1 eth0

if [ -n "${VRDEPORT}" ]; then
	echo "SET VRDE PORT"
	vboxmanage modifyvm $VM --vrde on
	vboxmanage modifyvm $VM --vrdeport ${VRDEPORT}
fi

if [ -n "${MEDIUM}" ]; then
	echo "MOUNT CD/DVD ISO "
	if [ -e ${MEDIUM} ]; then
		vboxmanage storageattach $VM --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $MEDIUM
  	else
    	echo "File not found..."		
	fi
fi

echo "\nfinish"
exit 0

