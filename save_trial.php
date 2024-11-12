<?php
# Treat warnings as errors
set_error_handler(function ($severity, $message, $file, $line) {
    throw new ErrorException($message, 0, $severity, $file, $line);
});

# Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    # Initialize response
    $response = ['success' => 1, 'message' => null];

    # Get the raw POST data
    $postData = file_get_contents('php://input');

    # Decode the JSON data
    $formData = json_decode($postData, true);

    # Save to disk
    try {
        # Erzeuge den den data/ Ordner
        if (!is_dir('data/')) { mkdir('data/'); }

        # Speicher den Datensatz als Dait
        $result = file_put_contents('data/' . $formData['filename'], $formData['dataset']);
        if ($result === false) {
            throw new Exception("Failed to write to file.");
        }
    } catch (Exception $e) {
        $response = ['success' => 0, 'message' => $e->getMessage()];
    }

    # Return response
    header('Content-Type: application/json');
    echo json_encode($response);

} else {
    # Handle invalid request method
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['message' => 'Only POST method is allowed']);
}
?>