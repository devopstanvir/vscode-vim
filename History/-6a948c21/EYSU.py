from http.server import SimpleHTTPRequestHandler, HTTPServer

HOST = "0.0.0.0"  # Listen on all interfaces
PORT = 80         # Default HTTP port

handler = SimpleHTTPRequestHandler

with HTTPServer((HOST, PORT), handler) as server:
    print(f"Serving on http://{HOST}:{PORT}")
    server.serve_forever()