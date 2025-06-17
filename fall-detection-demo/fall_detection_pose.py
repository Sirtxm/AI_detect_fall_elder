import cv2
from ultralytics import YOLO

model = YOLO("yolov8s-pose.pt")
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    results = model.predict(source=frame, stream=True, conf=0.4)
    for r in results:
        annotated_frame = r.plot()

        # ✅ เช็คว่ามี keypoints จริง และไม่ว่าง
        if r.keypoints is not None and r.keypoints.xy is not None and len(r.keypoints.xy) > 0:
            kps = r.keypoints.xy[0].cpu().numpy()

            # ✅ เช็คว่ามีจุดอย่างน้อยถึง index 12 (สะโพก)
            if kps.shape[0] > 12:
                nose_y = kps[0][1]
                hip_y = kps[12][1]  # สะโพกขวา

                if abs(nose_y - hip_y) < 30:
                    cv2.putText(annotated_frame, 'FALL DETECTED', (30, 60),
                                cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 255), 3)
                    print("[!] ล้มแล้ว")

        # แสดงผลลัพธ์
        cv2.imshow("YOLOv8 Fall Detection", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
