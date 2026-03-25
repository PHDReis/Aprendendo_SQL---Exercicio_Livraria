create table autor(
id_autor SERIAL primary key,
nome varchar(50) not null
);

create table livro(
id_livro SERIAL primary key,
titulo varchar(50) not null,
id_autor int, foreign key (id_autor)
references autor (id_autor)
on delete cascade
on update no action
);

create table usuario(
id_usuario SERIAL primary key,
nome varchar (50) not null,
email varchar (50) unique not null
);

create table emprestimo(
id_emprestimo SERIAL primary key,
data_emprestimo date not null,
data_devolucao date,
valor_emprestimo numeric (10,2) not null,
id_usuario int, foreign key (id_usuario)
references usuario (id_usuario),
id_livro int, foreign key (id_livro)
references livro (id_livro) on delete cascade
);

-- ################ --

/* POPULANDO */

insert into autor (nome) values 
('J J TOKKIEN'), 
('Lewis Carroll'), 
('Mauricio de Souza'), 
('Machado de Assis'), 
('Isaac Asimov'), 
('Gabriel Garcia Marques');

insert into livro (titulo, id_autor) values
('O Hobbit', 1),
('Alice do pais das maravilhas', 2),
('Almanaque', 3),
('Memorias Postumas de Braz Cubas', 4),
('Eu, ROBO', 5),
('100 anos de Solidão', 6),
('O Senhor dos Anéis', 1),
('Alice através do espelho', 2);

insert into usuario(nome, email) values
('Kevin Gonçalves', 'kirby@icloud.com'),
('Danille Carvalho', 'dani@batatinha.com'),
('Leonan Nogueira', 'Leono@gmail.com'),
('Pedro Reis', 'sopedro@outlook.com'),
('Gabriel Mendonça', 'isimover@gmail.com'),
('Simone Bromer', 'botasimone@bromer.com');

insert into emprestimo (data_emprestimo, data_devolucao, valor_emprestimo, id_usuario, id_livro) values
('2023-10-01', '2023-10-10', 15.00, 1, 1), 
('2023-10-02', '2023-10-12', 12.50, 2, 2), 
('2023-10-05', NULL, 10.00, 3, 3),         
('2023-10-07', '2023-10-15', 20.00, 4, 4), 
('2023-10-08', '2023-10-18', 18.00, 5, 5), 
('2023-10-10', '2023-10-20', 15.00, 6, 1), 
('2023-10-12', NULL, 25.00, 1, 4);        

/*Algumas query ́s pra construir:

1) Retornar os livros emprestados.
2) Retornar os livros que não foram emprestados.
3) Contar quantos livros foram emprestados.
4) A quantidade de livros que cada autor tem.
5) Exibir os livros do mais caro ao mais barato em ordem.
6) Apagar um autor consequentemente seu livro deverá ser
automaticamente apagado.
7) Mostra o total arrecado em empréstimo de um determinado livro

*/

--1
SELECT * FROM livro
right JOIN emprestimo
ON livro.id_livro = emprestimo.id_livro
WHERE emprestimo.data_devolucao is null;
--2
SELECT * FROM livro
LEFT JOIN emprestimo
ON livro.id_livro = emprestimo.id_livro
WHERE emprestimo.id_emprestimo IS NULL;
--3
SELECT livro.titulo,
COUNT(emprestimo.id_emprestimo) AS quantidade_emprestimos
FROM livro
INNER JOIN emprestimo
ON livro.id_livro = emprestimo.id_livro
GROUP BY livro.titulo
ORDER BY quantidade_emprestimos DESC;
--4
select  autor.nome, count(livro.id_livro) as quantidade_de_livros
from autor
inner join livro on  autor.id_autor = livro.id_autor 
group by autor.nome
order by autor.nome;
--5
select l.titulo, max(e.valor_emprestimo) as Valor from livro l
join emprestimo e on l.id_livro = e.id_livro
group by l.id_livro, l.titulo order by valor desc;
--6
DELETE FROM autor
WHERE nome = 'Lewis Carroll';
--7
SELECT livro.titulo, SUM(emprestimo.valor_emprestimo) AS total_arrecadado
FROM livro
INNER JOIN emprestimo
ON livro.id_livro = emprestimo.id_livro
GROUP BY livro.titulo;

