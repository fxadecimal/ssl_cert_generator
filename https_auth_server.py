#!/usr/bin/env python

# openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes -subj "/C=US/ST=Florida/L=Miami/O=Test Group/CN=testgroup.server5"

import BaseHTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler
import sys
import os
import base64
import ssl
import SocketServer

SERVER_KEY = "./build/server-key.pem"
SERVER_CERT = "./build/server-cert.pem"
HOSTNAME = "localhost"
PORT = 4443
BASIC_AUTH_USERNAME_PW = "test:test"

class AuthHandler(SimpleHTTPRequestHandler):
	''' Main class to present webpages and authentication. '''
	def do_HEAD(self):
		print "send header"
		self.send_response(200)
		self.send_header('Content-type', 'text/html')
		self.end_headers()

	def do_AUTHHEAD(self):
		print "send header"
		self.send_response(401)
		self.send_header('WWW-Authenticate', 'Basic realm=\"Test\"')
		self.send_header('Content-type', 'text/html')
		self.end_headers()

	def do_GET(self):
		global key
		''' Present frontpage with user authentication. '''
		if self.headers.getheader('Authorization') == None:
			self.do_AUTHHEAD()
			self.wfile.write('no auth header received')
			pass
		elif self.headers.getheader('Authorization') == 'Basic '+key:
			SimpleHTTPRequestHandler.do_GET(self)
			pass
		else:
			self.do_AUTHHEAD()
			self.wfile.write(self.headers.getheader('Authorization'))
			self.wfile.write('not authenticated')
			pass

def serve_https(https_port=80, HandlerClass = AuthHandler, ServerClass = BaseHTTPServer.HTTPServer, hostname="localhost", certfile=SERVER_CERT,keyfile=SERVER_KEY):
	httpd = ServerClass((hostname, https_port), HandlerClass)
	httpd.socket = ssl.wrap_socket (httpd.socket, certfile=SERVER_CERT, keyfile = SERVER_KEY, server_side=True)

	sa = httpd.socket.getsockname()
	print "Serving HTTPS on", sa[0], "port", sa[1], "..."
	httpd.serve_forever()



if __name__ == '__main__':
	if len(sys.argv)!=6:
		print ("usage python https_auth_server.py [hostname] [port] [username:password] [server key] [server certifcate]")

		print (" using default settings..")
		hostname, port, username_password, key_server, cert_server = \
			HOSTNAME, PORT, BASIC_AUTH_USERNAME_PW , SERVER_KEY, SERVER_CERT
	else:
		_, hostname, port, username_password, key_server, cert_server = sys.argv

	print "> python https_auth_server.py %(hostname)s %(port)s %(username_password)s %(key_server)s %(cert_server)s\n" % \
		dict(hostname=hostname, port=port, username_password=username_password, key_server=key_server, cert_server=cert_server )

	https_port = int(port)
	key = base64.b64encode(username_password)

	serve_https(https_port,certfile=cert_server,keyfile=key_server)
