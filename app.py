from flask import Flask, jsonify, request 
from flask_cors import CORS, cross_origin
import pickle
import numpy as np
app = Flask(__name__) 
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

# on the terminal type: curl http://127.0.0.1:5000/ 
# returns hello world when we use GET. 
# returns the data that we send when we use POST. 
@app.route('/', methods = ['GET', 'POST']) 
def home(): 
	if(request.method == 'GET'): 
		data = "hello world"
		return jsonify({'data': data}) 
	
@app.route('/predict', methods = ['GET', 'POST']) 
@cross_origin()
def predict(): 
	if(request.method == 'GET'): 
		data = "Please send data"
		return jsonify({'data': data})
	else:
		data = request.get_json()
		print(data)
		model = pickle.load(open('model.pkl','rb'))
		input_data = data['heart_data']
		input_data_as_np_array = np.asarray(input_data)
		input_data_reshaped = input_data_as_np_array.reshape(1,-1)

		prediction = model.predict(input_data_reshaped)
		prediction = int(prediction[0])
		print(prediction)

		if(prediction==0):
			return jsonify({'predict': prediction,'statement':'The person does not have a heart disease.'})
		else:
			return jsonify({'predict': prediction,'statement':'The person has heart disease.'})


# A simple function to calculate the square of a number 
# the number to be squared is sent in the URL when we use GET 
# on the terminal type: curl http://127.0.0.1:5000 / home / 10 
# this returns 100 (square of 10) 
@app.route('/home/<int:num>', methods = ['GET']) 
def disp(num): 
	return jsonify({'data': num**2}) 

if __name__ == '__main__': 
	app.run(host='0.0.0.0',port=4000) 
