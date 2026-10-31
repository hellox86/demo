const canvas = document.querySelector("canvas");

const ctx = canvas.getContext("2d");

let t = 0;
const imgData = ctx.createImageData(800, 600);
console.log(imgData.data.buffer); // (800*600)*4(pixel)


function plasma(t) {
    for (let i = 0; i < imgData.data.length; i+=4) {
	let src = i / 4;
	let x = src % 800;
	let y = src / 800;
	
	let w1 = Math.floor(((Math.sin(x*0.02+t) + 1) / 2) * 255);
	let w2 = Math.floor(((Math.sin(y*0.14+t) + 1) / 2) * 255);
	let w3 = Math.floor(((Math.sin(y*0.03+t) + 1) / 2) * 255);
	
	let w = (w1+w2+w3) / 3;

	imgData.data[i + 0] = 0;
	imgData.data[i + 1] = w;   
	imgData.data[i + 2] = 0;   
	imgData.data[i + 3] = 255;
    
    }


ctx.putImageData(imgData, 0, 0);
}

function plasma2(t) {
	for (let i = 0; i < imgData.data.length; i+=4) {
		let src = i / 4;
		let x = src % 800;
		let y = src / 800;
		let w1 = (Math.sin(x/3+t)+1)*255;
		let w2 = (Math.sin(y/5+t)+1)*255;
		let w3 = (Math.sin(0.27*(x*Math.sin(t)+y*Math.cos(t))+t))*127;
		let w = (w1+w2+w3) / 3;

		imgData.data[i + 0] = w;
		imgData.data[i + 1] = 0;   
		imgData.data[i + 2] = 0;   
		imgData.data[i + 3] = 255;
    
	}
	ctx.putImageData(imgData, 0, 0);
}

function l() {
    plasma2(t);
    t += 0.02;   
    requestAnimationFrame(l);
}

requestAnimationFrame(l);
    
