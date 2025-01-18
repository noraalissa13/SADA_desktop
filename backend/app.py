from quart import Quart, jsonify, request
from routes import register_routes

# Initialize the Quart app
app = Quart(__name__)

# Register routes from the routes.py file
register_routes(app)

if __name__ == '__main__':
    app.run(debug=True)
