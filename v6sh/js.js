var a=3;
var light=['cc', 'bb', 'dd']; 
// light.forEach(function(element, index, array) {
//     console.dir(element);
//     console.dir(index);
//     console.dir(array);
// });

function person(firstname,lastname,age,eyecolor)
{
    this.firstname=firstname;
    this.lastname=lastname;
    this.age=age;
    this.eyecolor=eyecolor;
}
var ren= new person('wu', "ming", 23, 'black'); 
//console.log(ren.firstname); 
console.log(window.appCodeName); 
