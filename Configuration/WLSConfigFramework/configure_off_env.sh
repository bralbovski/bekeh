#!/bin/sh -e
#
# Description      : Configure OFF Environment
#                     
# Input parameters : "SOA||OSB", Propperty File
# Related files    : setup.sh, configure.sh, prepare_env.sh, *.property, build.properties     
#                                 
# Owner            : Technical Services IIB
# Type             : Structural
# Expires          : n/a
# Created by       : yannisd         
# Created date     : 14:47:25, 31 May 2012
# Last updated by  : $Author: kdobris $     
# Last updated date: $Date: 2013-11-15 09:43:09 +0100 (Fri, 15 Nov 2013) $
# Revision         : $Rev: 33742 $

createUser()
{
	echo "Create a user"
    
	./setup.sh $1 USR-CREATION
}

createJMS()
{
	echo "Setup JMS $1"
	./setup.sh  $1 OFF-JMS-TEMPLATE
}

createDSOSB()
{
	export ds_all_prop_file=$1.property
	echo "Setup DS $1"
## If we clean all URL, USER and PASSWORD then the Properties File is getting broken, unless we have all props here too!!
	sed -i -e '/^DB_URL_DS/d' -e '/^DB_PASSWORD_DS/d' -e '/^DB_USER_DS/d'  properties/$ds_all_prop_file
	echo -e "DB_URL_DS_OFFTestDataSource=$ds_refdatadb_url" >> properties/$ds_all_prop_file
	echo -e "DB_USER_DS_OFFTestDataSource=$ds_refdatadb_username" >> properties/$ds_all_prop_file
	echo -e "DB_PASSWORD_DS_OFFTestDataSource=$ds_refdatadb_password" >> properties/$ds_all_prop_file
    if [ ! -z "$ds_refdatadb_onsnodelist" ]; then
		echo -e "OnsNodeList_DS_OFFTestDataSource=${ds_refdatadb_onsnodelist}" >> properties/$ds_all_prop_file
		echo -e "FanEnabled_DS_OFFTestDataSource=${ds_refdatadb_fanenabled:-true}" >> properties/$ds_all_prop_file
		echo -e "CONNECT_TIMEOUT_DS_OFFTestDataSource=${ds_refdatadb_connecttimeout:-1000}" >> properties/$ds_all_prop_file
		echo -e "DB_GLOBALTANSACTIONS_DS_OFFTestDataSource=TwoPhaseCommit" >> properties/$ds_all_prop_file
	fi

	echo -e "DB_URL_DS_HRDataSource=$ds_hr_url" >> properties/$ds_all_prop_file
	echo -e "DB_USER_DS_HRDataSource=$ds_hr_username" >> properties/$ds_all_prop_file
	echo -e "DB_PASSWORD_DS_HRDataSource=$ds_hr_password" >> properties/$ds_all_prop_file

	
	./setup.sh  $1 OFF-DS-ALL-TEMPLATE
}

createDSSOA()
{
	export ds_all_prop_file=$1.property
	echo "Setup DS $1"
## If we clean all URL, USER and PASSWORD then the Properties File is getting broken, unless we have all props here too!!
	sed -i -e '/^DB_URL_DS/d' -e '/^DB_PASSWORD_DS/d' -e '/^DB_USER_DS/d'  properties/$ds_all_prop_file
	

	echo -e "DB_URL_DS_HRDataSource=$ds_hr_url" >> properties/$ds_all_prop_file
	echo -e "DB_USER_DS_HRDataSource=$ds_hr_username" >> properties/$ds_all_prop_file
	echo -e "DB_PASSWORD_DS_HRDataSource=$ds_hr_password" >> properties/$ds_all_prop_file

	
	./setup.sh  $1 OFF-DS-ALL-TEMPLATE
}


createT3S()
{
	echo "Setup T3S Channel - It applies only to OSB"
	
	./setup.sh $1 CREATE-T3S-CHANNEL
	
}

createJCAFTP(){
	
	#echo "$0 function called with argument domainID=[${1}], propertyFile=[${2}]"
	#jcaAppName="FtpAdapter"
	
	export ftpa_all_prop_file=$2.property
	domain=$1
	JCA_FTP_RAR_LOCAL=FtpAdapter.rar
	
	if [ "${FMW_VERSION}" == "11g" ]; then
		if [ "$domain" = "OSB" ]
		then
			JCA_FTP_RAR_LOCAL=$FMW_HOME/Oracle_OSB1/soa/connectors/FtpAdapter.rar
		elif [ "$domain" = "SOA" ]
		then
			JCA_FTP_RAR_LOCAL=$FMW_HOME/Oracle_SOA1/soa/connectors/FtpAdapter.rar
		else
			echo "==== Domain not set" 
		fi
	else
		if [ "$domain" = "OSB" ]
		then
			JCA_FTP_RAR_LOCAL=$FMW_HOME/soa/soa/connectors/FtpAdapter.rar
		elif [ "$domain" = "SOA" ]
		then
			JCA_FTP_RAR_LOCAL=$FMW_HOME/soa/soa/connectors/FtpAdapter.rar
		else
			echo "==== Domain not set" 
		fi
		
	fi
  	echo "====FTPJCA ${JCA_FTP_RAR_LOCAL}" 

	
	sed -i -e '/^JCA_FTP_RAR_LOCAL/d' properties/$ftpa_all_prop_file
	echo -e "\nJCA_FTP_RAR_LOCAL=${JCA_FTP_RAR_LOCAL}" >> properties/$ftpa_all_prop_file
	#source ./setup.sh $2 CI-JCAFTP-TEMPLATE
	#createJCA "${1}" "${2}" ${jcaAppName}
	./create_resource.sh -r "JCAFTP" -p "${2}" -d "${1}" -b "${DOMAIN_BASE}" -s "${DOMAIN_SHARED}" -e ${WORKSPACE}/${ENV_PROP_DIR}/${ENV_PROP_FILE}
}

createJCADB()
{
    #jcaAppName="DbAdapter"
	export dba_all_prop_file=$2.property
	domain=$1
	JCA_DB_RAR_LOCAL=DbAdapter.rar
	
	if [ "${FMW_VERSION}" == "11g" ]; then
		if [ "$domain" = "OSB" ]
		then
			JCA_DB_RAR_LOCAL=$FMW_HOME/Oracle_OSB1/soa/connectors/DbAdapter.rar
		elif [ "$domain" = "SOA" ]
		then
			JCA_DB_RAR_LOCAL=$FMW_HOME/Oracle_SOA1/soa/connectors/DbAdapter.rar
		else
			echo "==== Domain not set" 
		fi
	else
		if [ "$domain" = "OSB" ]
		then
			JCA_DB_RAR_LOCAL=$FMW_HOME/soa/soa/connectors/DbAdapter.rar
		elif [ "$domain" = "SOA" ]
		then
			JCA_DB_RAR_LOCAL=$FMW_HOME/soa/soa/connectors/DbAdapter.rar
		else
			echo "==== Domain not set" 
		fi
	fi
  
	echo "$0 function called with argument domainID=[${1}], propertyFile=[${2}]"
	
	sed -i -e '/^JCA_DB_RAR_LOCAL/d' properties/$dba_all_prop_file
	echo -e "JCA_DB_RAR_LOCAL=${JCA_DB_RAR_LOCAL}" >> properties/$dba_all_prop_file
	#source ./setup.sh $2 CI-JCADB-TEMPLATE
	#createJCA "${1}" "${2}" ${jcaAppName}
	chmod 777 get_remote_files_v2.sh
	chmod 777 create_resource.sh
	./create_resource.sh -r "JCADB" -p "${2}" -d "${1}" -b "${DOMAIN_BASE}" -s "${DOMAIN_SHARED}" -e ${WORKSPACE}/${ENV_PROP_DIR}/${ENV_PROP_FILE}

}

if [[ -z "$WORKSPACE" ]]
then 
	# 20130910 WVE. If WORKSPACE is not set, assume it is the current working directory. For compatibility with Bamboo.
	#echo "Please define WORKSPACE enviroment variable (to the dir containing setup.sh)"
	#exit 1;
	echo "Assuming setup.sh script is in current directory."
else 
	echo "Workspace is [$WORKSPACE]"
	cd $WORKSPACE/WLSConfigFramework
	chmod u+x setup.sh
	chmod u+x configure.sh
	chmod u+x scripts/prepare_env.sh
fi

if [[ -z "$resource_to_create" ]]
then 
	export resource_to_create=ALL
fi


. "$2"

export DERBYDIR=DERBY
export PROPERTIES_DIR=properties
export WLS_HOME=$FMW_HOME
echo "Current working directory is: $(pwd)"
echo "WLS_HOME=$WLS_HOME"

domainlist="SOA OSB ALL"
# Note: this check is not entirely correct, as substrings (e.g. "A") as the argument to this script are considered correct.
if [[ "$domainlist" != *"$1"* ]]; then
	echo "Please define DOMAIN enviroment variable (SOA or OSB), exit " 
	exit 1
fi

###START MODIFY DERBY/build.properties
if [ "$1" = "SOA" ] || [ "$1" = "ALL" ];
then
	echo "Setting DERBYDIR build.properties for [$domain]"
	echo -e "deploy.admin.user=$deploy_soa_admin_user" > $DERBYDIR/build.properties
	echo -e "deploy.admin.password=$deploy_soa_admin_password" >> $DERBYDIR/build.properties
	echo -e "deploy.admin.port=$deploy_soa_admin_port" >> $DERBYDIR/build.properties
	echo -e "deploy.admin.hostname=$deploy_soa_host" >> $DERBYDIR/build.properties
	echo -e "deploy.osb.server1=$deploy_soa_server1" >> $DERBYDIR/build.properties
	echo -e "deploy.osb.server2=$deploy_soa_server2" >> $DERBYDIR/build.properties
	echo -e "deploy.cluster=$deploy_soa_cluster" >> $DERBYDIR/build.properties
	if [[ "$resource_to_create" = "JMS" ]] ||  [[ "$resource_to_create" = "ALL" ]] 
	then
		echo "creating SOA JMS ..."
		#createJMS OFF-JMS-TESTALLSOA-PROPERTY 
	fi
	if [[ "$resource_to_create" = "DS" ]] ||  [[ "$resource_to_create" = "ALL" ]] 
	then
		echo "creating SOA DS ..."
		#createDSSOA OFF-DS-TESTSOA-PROPERTY
	fi
fi

if [ "$1" = "OSB" ] || [ "$1" = "ALL" ];
then
	. "$2"
	
	echo "Setting DERBYDIR build.properties for [$1]"
	echo -e "deploy.admin.user=$deploy_osb_admin_user" > $DERBYDIR/build.properties
	echo -e "deploy.admin.password=$deploy_osb_admin_password" >> $DERBYDIR/build.properties
	echo -e "deploy.admin.port=$deploy_osb_admin_port" >> $DERBYDIR/build.properties
	echo -e "deploy.admin.hostname=$deploy_osb_host" >> $DERBYDIR/build.properties
	echo -e "deploy.osb.server1=$deploy_osb_server1" >> $DERBYDIR/build.properties
	echo -e "deploy.osb.server2=$deploy_osb_server2" >> $DERBYDIR/build.properties
	echo -e "deploy.cluster=$deploy_osb_cluster" >> $DERBYDIR/build.properties
	if [[ "$resource_to_create" = "DS" ]] ||  [[ "$resource_to_create" = "ALL" ]] 
	then
		echo "creating OSB DS ..."
		#createDSOSB OFF-DS-TESTOSB-PROPERTY
	fi
	if [[ "$resource_to_create" = "JMS" ]] ||  [[ "$resource_to_create" = "ALL" ]] 
	then
		echo "creating OSB JMS ..."
		#createJMS OFF-JMS-TESTALLOSB-PROPERTY	
	fi
	if [[ "$resource_to_create" = "JCAFTP" ]] ||  [[ "$resource_to_create" = "ALL" ]]  && [[ "${SUDO_EXISTS}" = "true" ]]
	then
		echo "creating JCAFTP ..."
		#createJCAFTP OSB OFF-TESTJCAFTP-OSB-PROPERTY
	fi
	if [[ "$resource_to_create" = "JCADB" ]] ||  [[ "$resource_to_create" = "ALL" ]]  && [[ "${SUDO_EXISTS}" = "true" ]]
	then
		echo "creating JCADB ..."
		#createJCADB OSB OFF-TESTJCADB-OSB-PROPERTY
	fi
	
	if [[ "$resource_to_create" = "USER" ]] ||  [[ "$resource_to_create" = "ALL" ]] 
	then
		echo "creating OFF Users ..."
		#createUser OFF-USER-HR-AUDIT-OSB-PROPERTY
	fi
fi



