function sol = PuzzleRead(imageName)
    camList = webcamlist
    cam = webcam(1)
    preview(cam);
    img = snapshot(cam);
    image(img);
    clear cam
    I = img;%imread(image(img));
      figure;
     imshow(I);
    results = ocr(I);   
    sol = CleanUpText(results.Text);
end

function out = CleanUpText(input)
    out = str2double(regexp(num2str(input),'\d','match'));
end
