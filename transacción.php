<?php
// Config conection
$username = 'root';
$password = '12345678';
$dbName = 'dcleaner';
$connectionName = getenv("prueba-de-vpc:us-central1:prueba");
$socketDir = getenv('DB_SOCKET_DIR') ?: '/cloudsql';

// Connect using UNIX sockets
$dsn = sprintf(
    'mysql:dbname=%s;unix_socket=%s/%s',
    $dbName,
    $socketDir,
    $connectionName
);
// Connect to the database.
$conn = new PDO($dsn, $username, $password, $conn_config);
// Check connection
if (!$conn) {
      die("Connection failed: " . mysqli_connect_error());
}

echo "Connected successfully";

//Retrive Data
$cantidad = $_POST['cantidad'];
$pago = $_POST['pago'];
$ciudad = $_POST['ciudad'];
$total = $cantidad * 8.56;

$sql = "INSERT INTO transacciones (prod_id, cliente_id, descripcion, cantidad, total, tipo_pago, fecha, ciudad) values
(1, 1, 'cubrebocas',".$cantidad.",".$total.",'".$pago."','".date('Y-m-d')."', '".$ciudad."')";

$statement = $pdo->prepare($sql);
$statement->execute();
?>
