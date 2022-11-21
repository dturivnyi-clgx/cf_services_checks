#!/usr/bin/env bash
if [ "$1" == "" ]
then
  echo "Please provide the path to the application archive."
  exit 1
fi

if [ ! -z "`cf m | grep "p\.config-server"`" ]; then
  export service_name="p.config-server"
elif [ ! -z "`cf m | grep "p-config-server"`" ]; then
  export service_name="p-config-server"
else
  echo "Can't find SCS Config Server in marketplace. Have you installed the SCS Tile?"
  exit 1;
fi

echo -n "Creating Config Server..."
{
  cf create-service -c '{ "git": { "uri": "https://github.com/dturivnyi-clgx/cf_services_checks/config-server/config-server-test", "label": "main"  } }' ${service_name} standard config-server-test
} &> /dev/null
until [ `cf service config-server-test | grep -c "succeeded"` -eq 1  ]
do
  echo -n "."
done
echo
echo "Config Server created. Pushing application."
cf push -p "$@"
echo "Done!"
