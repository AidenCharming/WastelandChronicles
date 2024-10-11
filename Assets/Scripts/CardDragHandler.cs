using UnityEngine;

public class CardDragHandler : MonoBehaviour
{
    private Vector3 offset;
    private CameraController cameraController;
    private bool isDraggingCard = false;
    private float cameraDragCooldown = 0.2f; // Time to wait after camera drag ends
    private float cooldownTimer = 0f;

    private void Start()
    {
        // Find the CameraController script to check if the camera is being dragged
        cameraController = Camera.main.GetComponent<CameraController>();
    }

    private void Update()
    {
        // Update cooldown timer if it is active
        if (cooldownTimer > 0)
        {
            cooldownTimer -= Time.deltaTime;
        }

        // If the camera is being dragged, stop card dragging
        if (cameraController != null && cameraController.IsCameraDragging() && isDraggingCard)
        {
            isDraggingCard = false;
            cooldownTimer = cameraDragCooldown; // Set cooldown after camera dragging ends
        }
    }

    private void OnMouseDown()
    {
        // Do not allow card dragging if the camera is currently being dragged or cooldown is active
        if ((cameraController != null && cameraController.IsCameraDragging()) || cooldownTimer > 0)
        {
            return;
        }

        Vector3 mouseWorldPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        mouseWorldPosition.z = 0; // Set z to 0 to keep the object in the 2D plane
        offset = transform.position - mouseWorldPosition;
        isDraggingCard = true;
    }

    private void OnMouseDrag()
    {
        // Do not allow card dragging if the camera is currently being dragged or cooldown is active
        if ((cameraController != null && cameraController.IsCameraDragging()) || cooldownTimer > 0)
        {
            return;
        }

        if (isDraggingCard)
        {
            Vector3 mouseWorldPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            mouseWorldPosition.z = 0; // Keep the card at the correct z-axis position
            transform.position = mouseWorldPosition + offset;
        }
    }

    private void OnMouseUp()
    {
        isDraggingCard = false;
    }
}