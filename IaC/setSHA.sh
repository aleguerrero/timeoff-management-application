wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
mkdir myagent && cd myagent
tar zxvf ~/vsts-agent-linux-x64-3.218.0.tar.gz
./config.sh
sudo ./svc.sh install
sudo ./svc.sh start
# ./run.sh