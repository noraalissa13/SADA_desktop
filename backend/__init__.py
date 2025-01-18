from quart import Quart, jsonify, request
from routes import register_routes

app = Quart(__name__)

# Register routes from the routes.py file
register_routes(app)
