<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "taskmanager";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Koneksi ke database gagal: " . $conn->connect_error);
}
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
    // Mengambil data mahasiswa
    $sql = "SELECT * FROM task";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $task = array();
        while ($row = $result->fetch_assoc()) {
            $task[] = $row;
        }
        echo json_encode($task);
    }
    else {
        echo "Data task kosong.";
    }
}
if ($method === "POST") {
    // Menambahkan data mahasiswa
    $data = json_decode(file_get_contents("php://input"), true);
    $task = $data["task"];
    $isfinished = false;
    $sql = "INSERT INTO task (task, isfinished) VALUES ('$task', '$isfinished')";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "PUT") {
    // Memperbarui data mahasiswa
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $isfinished = true;
    $sql = "UPDATE task SET isfinished='$isfinished' WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = "berhasil";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "DELETE") {
    // Menghapus data mahasiswa
    $id = $_GET["id"];
    $sql = "DELETE FROM task WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
?>