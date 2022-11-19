/*Creacion de tablas para el desafio 3*/

/*CREACION BASE DE DATOS y direccionamiento a la base de datos*/

CREATE DATABASE luis_urbaneja_258;

\c luis_urbaneja_258;

/*creacion de tabla usuarios*/

CREATE TABLE users (id SERIAL PRIMARY KEY, email VARCHAR (50) NOT NULL, nombre VARCHAR (50) NOT NULL, apellido VARCHAR (50) NOT NULL, rol VARCHAR (50) NOT NULL, CHECK (rol = 'administrador' OR rol = 'usuario'));

/*insertar datos de usuarios*/

INSERT INTO users (email, nombre, apellido, rol) VALUES ('zero502012@gmail.com', 'zero', 'mega', 'administrador'), ('lurbaneja27@gmail.com', 'luis', 'urbaneja', 'administrador'), ('marige261092@gmail.com', 'marianela', 'gamboa', 'usuario'), ('sepaverano1@gmail.com', 'pavel', 'serrano', 'usuario'), ('ledyamado@gmail.com', 'ledymar', 'amado', 'usuario');

/*creacion de tabla post*/

CREATE TABLE posts (id SERIAL PRIMARY KEY, title VARCHAR (50), contents TEXT, date_creation TIMESTAMP, date_update TIMESTAMP, feature BOOLEAN, user_id BIGINT CHECK (feature = 'True' OR feature = 'False'));
    
/*insertar datos en posts */

INSERT INTO posts (title, contents, date_creation, date_update, feature, user_id) VALUES ('prueba inicial', 'sql', '07-07-2022', '07-07-2022', True, 1), ('prueba 2', 'js', '10-01-2022', '01-02-2022', True, 2), ('pruebas de areas', 'sql', '05-05-2022', '05-05-2022', False, 3), ('Pasantia', 'js', '07-07-2022', '07-07-2022', False, 4), ('Pasantia', 'css 3', '04-02-2022', '04-02-2022', False, NULL);

/*creacion de tabla coment*/

CREATE TABLE coment (id SERIAL PRIMARY KEY, contents TEXT, date_creation TIMESTAMP NOT NULL, user_id BIGINT NOT NULL, post_id BIGINT NOT NULL);
    
/*insertar datos en coment */

INSERT INTO coment (contents, date_creation, user_id, post_id) VALUES ('el paquete fue entregado', '2022-07-28', 1, 1), ('aqui esta el nuevo mensaje', '2022-07-29', 2, 1), ('aqui no tendremos fiesta', '2022-07-30', 3, 1), ('tendremos partido hoy?', '2022-07-31', 1, 2), ('estare activo para lo que viene', '2022-07-27', 2, 2);

/*Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas nombre e email del usuario junto al título y contenido del post.*/ 

SELECT u.nombre, u.email, p.title, p.contents FROM users AS u JOIN posts AS p ON u.id = p.user_id;
  nombre   |         email          |      title       | contents
-----------+------------------------+------------------+----------
 zero      | zero502012@gmail.com   | prueba inicial   | sql
 luis      | lurbaneja27@gmail.com  | prueba 2         | js
 marianela | marige261092@gmail.com | pruebas de areas | sql
 pavel     | sepaverano1@gmail.com  | Pasantia         | js
(4 filas)

/*Muestra el id, título y contenido de los posts de los administradores. 
El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.*/

SELECT u.id, p.title, p.contents FROM posts AS p JOIN users AS u ON p.user_id = u.id WHERE u.rol ='administrador';
 id |     title      | contents
----+----------------+----------
  1 | prueba inicial | sql
  2 | prueba 2       | js
(2 filas)

/*Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id junto al email del usuario junto con la cantidad de posts de cada usuario.*/

SELECT u.id AS "ID", u.email AS "Email", count(p.user_id) AS "Cantidad Posts" FROM users AS u LEFT JOIN posts AS p ON u.id = p.user_id GROUP BY p.user_id, u.id, u.email;
 ID |         Email          | Cantidad Posts
----+------------------------+----------------
  1 | zero502012@gmail.com   |              1
  2 | lurbaneja27@gmail.com  |              1
  5 | ledyamado@gmail.com    |              0
  3 | marige261092@gmail.com |              1
  4 | sepaverano1@gmail.com  |              1
(5 filas)

/*Muestra la fecha del último post de cada usuario.*/

SELECT u.nombre, MAX(p.date_creation) as "Fecha ultimo Post" FROM users AS u INNER JOIN posts AS p ON u.id = p.user_id GROUP BY p.user_id, u.nombre;

  nombre   |  Fecha ultimo Post
-----------+---------------------
 pavel     | 2022-07-07 00:00:00
 luis      | 2022-01-10 00:00:00
 zero      | 2022-07-07 00:00:00
 marianela | 2022-05-05 00:00:00
(4 filas)

/*Muestra el título y contenido del post (artículo) con más comentarios.*/

SELECT p.title, p.contents FROM coment AS c INNER JOIN posts AS p ON c.post_id = p.id GROUP BY c.post_id, p.title, p.contents ORDER BY post_id asc limit 1;
     title      | contents
----------------+----------
 prueba inicial | sql
(1 fila)

/*Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
*/

SELECT p.title, p.contents As "Contenido Post", c.contents AS "Contenido Comentarios", u.email FROM posts AS p INNER JOIN coment AS c ON p.id = c.post_id INNER JOIN users AS u ON c.user_id = u.id;
     title      | Contenido Post |      Contenido Comentarios      |         email
----------------+----------------+---------------------------------+------------------------
 prueba inicial | sql            | el paquete fue entregado        | zero502012@gmail.com
 prueba inicial | sql            | aqui esta el nuevo mensaje      | lurbaneja27@gmail.com
 prueba inicial | sql            | aqui no tendremos fiesta        | marige261092@gmail.com
 prueba 2       | js             | tendremos partido hoy?          | zero502012@gmail.com
 prueba 2       | js             | estare activo para lo que viene | lurbaneja27@gmail.com
(5 filas)

/*Muestra el contenido del último comentario de cada usuario.*/

SELECT c.user_id, c.date_creation, c.contents FROM coment AS c INNER JOIN (SELECT MAX(c.id) AS max_id_search FROM coment AS c GROUP BY user_id) AS max_result ON c.id = max_result.max_id_search ORDER BY c.user_id;
 user_id |    date_creation    |            contents
---------+---------------------+---------------------------------
       1 | 2022-07-31 00:00:00 | tendremos partido hoy?
       2 | 2022-07-27 00:00:00 | estare activo para lo que viene
       3 | 2022-07-30 00:00:00 | aqui no tendremos fiesta
(3 filas)

/*Muestra los emails de los usuarios que no han escrito ningún comentario.*/

SELECT u.email FROM users AS u LEFT JOIN coment AS c ON u.id = c.user_id GROUP BY u.email, c.contents HAVING c.contents IS NULL;
