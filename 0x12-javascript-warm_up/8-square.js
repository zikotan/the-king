#!/usr/bin/node

const size = Math.floor(Number(process.argv[2]));
let r, c, row;
if (isNaN(size)) {
  console.log('Missing size');
} else {
  for (r = 0; r < size; r++) {
    row = '';
    for (c = 0; c < size; c++) row += 'X';
    console.log(row);
  }
}
