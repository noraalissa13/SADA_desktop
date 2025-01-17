<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SADA: A BCI-Based Student Attention Deficit Alert and Profiling System</title>
</head>
<body>
    <h1>SADA: A BCI-Based Student Attention Deficit Alert and Profiling System</h1>
    <p>
        SADA is an innovative project that combines Brain-Computer Interface (BCI) technology, machine learning, and real-time data visualization 
        to monitor and analyze students' attention levels. Designed to address attention deficits in modern educational environments, SADA provides 
        actionable insights to foster self-awareness and improve learning outcomes.
    </p>
    <h2>Features</h2>
    <ul>
        <li>Real-time EEG data streaming and preprocessing from Muse headbands.</li>
        <li>Attention deficit detection using Long Short-Term Memory (LSTM) models.</li>
        <li>Interactive and dynamic visualization of attention levels.</li>
        <li>Backend built with Python and Quart for efficient data processing.</li>
        <li>Flutter-based frontend for mobile and desktop platforms.</li>
    </ul>
    <h2>System Architecture</h2>
    <p>
        The SADA system is composed of multiple modules working together seamlessly:
    </p>
    <ul>
        <li><strong>EEG Data Streaming:</strong> Real-time streaming of brainwave data using Muse SDK.</li>
        <li><strong>Data Preprocessing:</strong> Signal filtering and feature extraction to prepare data for analysis.</li>
        <li><strong>Machine Learning:</strong> LSTM models for detecting attention levels based on EEG signals.</li>
        <li><strong>Visualization:</strong> Real-time attention level graphs using a line chart in the Flutter frontend.</li>
        <li><strong>Backend Services:</strong> REST API built with Quart for handling data processing and communication.</li>
    </ul>
    <h2>Installation</h2>
    <h3>Backend Setup</h3>
    <ol>
        <li>Clone this repository:</li>
        <pre><code>git clone https://github.com/your-username/sada.git</code></pre>
        <li>Navigate to the backend directory:</li>
        <pre><code>cd sada/backend</code></pre>
        <li>Install dependencies:</li>
        <pre><code>pip install -r requirements.txt</code></pre>
        <li>Run the Quart server:</li>
        <pre><code>python app.py</code></pre>
    </ol>    
    <h3>Frontend Setup</h3>
    <ol>
        <li>Ensure Flutter is installed and set up on your machine.</li>
        <li>Navigate to the frontend directory:</li>
        <pre><code>cd sada/frontend</code></pre>
        <li>Install dependencies:</li>
        <pre><code>flutter pub get</code></pre>
        <li>Run the Flutter app:</li>
        <pre><code>flutter run</code></pre>
    </ol>   
    <h2>Usage</h2>
    <p>
        1. Connect the Muse headband and ensure it is paired with your device.<br>
        2. Launch the backend server to handle EEG data streaming and processing.<br>
        3. Start the Flutter app to view real-time visualizations of attention levels.<br>
        4. Use the insights provided by the system to monitor and improve attention during learning sessions.
    </p>   
    <h2>Results</h2>
    <p>
        The SADA system achieved a classification accuracy of <strong>XX%</strong> using the LSTM model, demonstrating its effectiveness in detecting attention deficits. 
        The real-time visualization feature provides an intuitive way for users to monitor attention levels dynamically.
    </p>
    <h2>Technologies Used</h2>
    <ul>
        <li>Python (Quart, NumPy, SciPy, Scikit-learn)</li>
        <li>Flutter (Dart)</li>
        <li>Muse SDK</li>
        <li>Machine Learning (LSTM)</li>
    </ul>
    <h2>Contributing</h2>
    <p>
        Contributions are welcome! Please fork this repository and submit a pull request with your changes.
    </p> 
    <h2>License</h2>
    <p>
        This project is licensed under the <a href="https://opensource.org/licenses/MIT">MIT License</a>.
    </p>
    <h2>Contact</h2>
    <p>
        For questions or feedback, feel free to reach out to <a href="mailto:your-email@example.com">your-email@example.com</a>.
    </p>
</body>
</html>
