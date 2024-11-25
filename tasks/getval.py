#!/usr/bin/env python3

import os, sys
import subprocess
import socket

sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python_task_helper', 'files'))
from task_helper import TaskHelper


class GetVal(TaskHelper):
    def get_metric(self, hostname, metric):
        fullmetric = hostname+'/'+metric
        return subprocess.check_output(['/usr/bin/collectdctl', 'getval',fullmetric]).rstrip().decode().split('\n')

    def task(self, args):
        if 'hostname' in args:
            hosts = [args['hostname']]
        else:
            hosts = [socket.gethostname(), socket.getfqdn()]

        for host in hosts:
            try:
                results = self.get_metric(host, args['metric'])
                break
            except:
                continue

        values = { k:v for k,v in (x.split('=')  for x in results)}
        return {
                  'metric': args['metric'],
                  'values': values
               }

if __name__ == '__main__':
    GetVal().run()

