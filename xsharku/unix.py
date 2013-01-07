# Copyright 2013 Johan Rydberg.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import _socket

def bind_unix_listener(path, backlog=50, user=None):
    sock = _socket.socket(_socket.AF_UNIX, _socket.SOCK_STREAM)
    sock.setblocking(0)
    sock.bind(path)
    sock.listen(backlog)
    return sock
