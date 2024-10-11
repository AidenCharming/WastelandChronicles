using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class CameraController : MonoBehaviour
{
    [Header("Movement Settings")]
    // Speed at which the camera moves using the WASD keys
    public float panSpeed = 20f;
    // Speed at which the camera moves when dragging with the mouse
    public float dragSpeed = 2f;
    
    [Header("Zoom Settings")]
    // Speed of zooming in and out
    public float zoomSpeed = 2f;
    // Minimum and maximum zoom levels
    public float minZoom = 1f;
    public float maxZoom = 15f;
    
    // Stores the initial position when starting to drag the camera
    private Vector3 dragOrigin;
    // Reference to the main camera
    private Camera cam;
    // Boolean to check if we are currently dragging the camera
    private bool isDragging = false;
    // Layer mask to prevent dragging when clicking on a card
    public LayerMask cardLayer;
    // Boolean to check if camera dragging is active
    private bool isCameraDragging = false;
    // Reference to the Rigidbody2D component
    private Rigidbody2D rb;

    void Start()
    {
        // Get the main camera reference
        cam = Camera.main;
        // Get the Rigidbody2D component attached to the camera
        rb = GetComponent<Rigidbody2D>();
        rb.gravityScale = 0; // Ensure there is no gravity affecting the camera
    }

    void Update()
    {
        HandleKeyboardMovement();
        HandleMouseDrag();
        HandleZoom();
    }

    void HandleKeyboardMovement()
    {
        Vector2 move = new Vector2();

        if (Input.GetKey(KeyCode.W))
        {
            move.y += 1;
        }
        if (Input.GetKey(KeyCode.S))
        {
            move.y -= 1;
        }
        if (Input.GetKey(KeyCode.A))
        {
            move.x -= 1;
        }
        if (Input.GetKey(KeyCode.D))
        {
            move.x += 1;
        }

        // Move the camera using Rigidbody2D for smooth movement
        rb.linearVelocity = move * panSpeed;
    }

    void HandleMouseDrag()
    {
        // Capture the initial mouse position when left mouse button is pressed down
        if (Input.GetMouseButtonDown(0) && !Input.GetMouseButton(1))
        {
            if (IsPointerOverUIObject() || IsPointerOverCard())
                return;

            dragOrigin = cam.ScreenToWorldPoint(Input.mousePosition);
            dragOrigin.z = 0;
            isDragging = true;
            isCameraDragging = true;
        }

        // Drag the camera while the left mouse button is held down
        if (Input.GetMouseButton(0) && isDragging)
        {
            Vector3 currentPosition = cam.ScreenToWorldPoint(Input.mousePosition);
            currentPosition.z = 0;
            Vector3 difference = dragOrigin - currentPosition;
            difference.z = 0;
            rb.MovePosition(rb.position + new Vector2(difference.x, difference.y) * dragSpeed);

            // Update the drag origin for smooth movement
            dragOrigin = currentPosition;
        }

        // Stop dragging when the left mouse button is released
        if (Input.GetMouseButtonUp(0))
        {
            isDragging = false;
            isCameraDragging = false;
            rb.linearVelocity = Vector2.zero; // Stop any movement when dragging ends
        }
    }

    void HandleZoom()
    {
        // Get the scroll wheel input for zooming
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0.0f)
        {
            float newSize = cam.orthographicSize - scroll * zoomSpeed;
            cam.orthographicSize = Mathf.Clamp(newSize, minZoom, maxZoom);
        }
    }

    private bool IsPointerOverUIObject()
    {
        return UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject();
    }

    private bool IsPointerOverCard()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        RaycastHit2D hit = Physics2D.GetRayIntersection(ray, Mathf.Infinity, cardLayer);
        return hit.collider != null;
    }

    public bool IsCameraDragging()
    {
        return isCameraDragging;
    }
}