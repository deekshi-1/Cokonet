let print = " "
for (let index = 1; index <=10 ; index++) {
    print += index + " ";
}
console.log(print);

print = " "
for (let index = 1; index <=10 ; index++) {
    if(index % 2 === 0){
        print += index + " ";
    }
}
console.log(print);