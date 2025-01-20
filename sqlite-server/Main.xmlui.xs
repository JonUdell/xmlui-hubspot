function sql() {
  return JSON.stringify( {  sql: "INSERT INTO books (title, author) VALUES ('Dune', 'Frank Herbert')" } )
}

function sql2(title, author) {
  console.log('1', title, author)
  let result = JSON.stringify({
    sql: `INSERT INTO books (title, author) VALUES ('${title}', '${author}')`
  });
  console.log('2', result)
  return result
}


