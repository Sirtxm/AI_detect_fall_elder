from ultralytics import YOLO

model = YOLO("yolov8s.pt")

model.train(
    data="C:/ProjectHIU/fall-dataset/data.yaml",
    epochs=50,
    imgsz=640,
    batch=8,
    name="fall_yolo_model"
)