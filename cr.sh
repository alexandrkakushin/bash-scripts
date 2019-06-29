#!/bin/bash
# Подключение к хранилищу конфигурации и выгрузка конфигурации в XML-файлы

printf "Адрес хранилища: " 
	read ConfigurationRepositoryF
printf "Пользователь: " 
	read ConfigurationRepositoryN
printf "Пароль: " 
	read ConfigurationRepositoryP		

printf "..."

DIR="/tmp/cr"
DIR_BASE="${DIR}/base"
DIR_XML="${DIR}/xml"
THICK_CLIENT="/opt/1C/v8.3/x86_64/1cv8"

if [ -e ${DIR} ]; then
  rm -R ${DIR}
fi

mkdir ${DIR}
mkdir ${DIR_XML}
mkdir ${DIR_BASE}

printf "\nСоздание временной ИБ"
${THICK_CLIENT} CREATEINFOBASE File="${DIR_BASE}"

printf "\nЗагрузка конфигурации из хранилища"
${THICK_CLIENT} DESIGNER /F "${DIR_BASE}" /ConfigurationRepositoryF "${ConfigurationRepositoryF}" /ConfigurationRepositoryN "${ConfigurationRepositoryN}" /ConfigurationRepositoryP "${ConfigurationRepositoryP}" /ConfigurationRepositoryUpdateCfg

printf "\nВыгрузка конфигурации в файлы"
${THICK_CLIENT} DESIGNER /F "${DIR_BASE}" /DumpConfigToFiles "${DIR_XML}"

printf "\n...\n${DIR_XML}\n"

ls -la ${DIR_XML}
