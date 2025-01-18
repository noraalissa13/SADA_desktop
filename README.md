<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>SADA: A BCI-Based Student Attention Deficit Alert and Profiling System</h1>
    <p>
        SADA is an innovative project that combines Brain-Computer Interface (BCI) technology, machine learning, and real-time data visualization 
        to monitor and analyze students' attention levels. Designed to address attention deficits in modern educational environments, SADA provides 
        actionable insights to foster self-awareness and improve learning outcomes.
    </p>
    <h2>Features</h2>
    <table>
        <thead>
            <tr>
                <th>Feature</th>
                <th>Description</th>
                <th>Functionality</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Real-time EEG Data Streaming</td>
                <td>Streams EEG data from Muse headbands for immediate analysis.</td>
                <td>Facilitates live data collection and preprocessing for accurate monitoring.</td>
            </tr>
            <tr>
                <td>Attention Deficit Detection</td>
                <td>Uses Long Short-Term Memory (LSTM) models to analyze brain activity.</td>
                <td>Identifies patterns indicative of attention deficits with high accuracy.</td>
            </tr>
            <tr>
                <td>Interactive Visualization</td>
                <td>Provides dynamic visual feedback on attention levels in real time.</td>
                <td>Enhances user engagement and understanding of their attention states.</td>
            </tr>
            <tr>
                <td>Python and Quart Backend</td>
                <td>Processes EEG data efficiently with a robust backend architecture.</td>
                <td>Ensures smooth data handling and supports machine learning pipelines.</td>
            </tr>
            <tr>
                <td>Flutter-based Frontend</td>
                <td>Cross-platform interface for both mobile and desktop applications.</td>
                <td>Delivers a seamless and user-friendly experience across devices.</td>
            </tr>
        </tbody>
    </table>
    <h2>User Interface</h2>
    Main Page
    <br>
    <img width="600" alt="Sada Main Page" src="https://github.com/user-attachments/assets/f25c5ead-c206-401f-9eb6-641e0bcd7aeb">
    <br> 
    Connect Device Page
    <br>
    <img width="600" alt="Sada Main Page" src="https://github.com/user-attachments/assets/56e97754-798c-4a00-9886-a98ef022f207">
    <br>
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
        <pre><code>git clone https://github.com/noraalissa13/SADA_desktop.git</code></pre>
        <li>Navigate to the backend directory:</li>
        <pre><code>cd SADA_desktop/backend</code></pre>
        <li>Install dependencies:</li>
        <pre><code>pip install -r requirements.txt</code></pre>
        <li>Run the Quart server:</li>
        <pre><code>python app.py</code></pre>
    </ol>    
    <h3>Frontend Setup</h3>
    <ol>
        <li>Ensure Flutter is installed and set up on your machine.</li>
        <li>Navigate to the frontend directory:</li>
        <pre><code>cd SADA_desktop</code></pre>
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
        The SADA system achieved a classification accuracy of <strong>98%</strong> using the LSTM model, demonstrating its effectiveness in detecting attention deficits. 
        The real-time visualization feature provides an intuitive way for users to monitor attention levels dynamically.
    </p>
    <h2>Technologies Used</h2>
    <ul>
        <li>Python (Quart, NumPy, SciPy, Scikit-learn)</li>
        <li>Flutter (Dart)</li>
        <li>Muse SDK</li>
        <li>Machine Learning (LSTM)</li>
    </ul>
    <h2>Future Work</h2>
    <ul>
        <li>Implement alert generation when attention levels is "Low".</li>
        <li>Integrate adaptive neurofeedback.</li>
        <li>Incorporate user profiling and personalized learning.</li>
    </ul>
    <h2>License</h2>
    <p>
        This project is licensed under the <a href="https://opensource.org/licenses/MIT">MIT License</a>.
    </p>
    <h2>Contact</h2>
    <p>For inquiries, contact:</p>
    <ul>
        <li><strong>Developers:</strong> <br>1. Nora Alissa binti Ismail <br>2. Hayani Nazurah binti Hasram<br>3. Dini Oktarina Dwi Handayani, Asst. Prof. Ts. Dr.</li>
        <li><strong>Email:</strong> <br>1. noraalissa13@gmail.com<br>2. hayaninazurah29@gmail.com<br>3. dinihandayani@iium.edu.my </li>
        <li><strong>Institution:</strong> International Islamic University Malaysia</li>
    </ul>
</body>
</html>
