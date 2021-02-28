using UnityEngine;


public class CameraFollowScript : MonoBehaviour
{
    [Tooltip("Select Target for camera follow")]
    [SerializeField] private Transform target;
    [SerializeField] private float followHeight;
    [SerializeField] private float followDistance;
    [SerializeField] private float followX;
    [SerializeField] private float smoothness;
    [SerializeField] private float lerpClamp;
    private float desiredHeight;
    private float desiredDistance;
    private float desiredX;
    [SerializeField] private float lookAtRotation;
    GameManager gameManager;

    private void Start()
    {
       gameManager = FindObjectOfType<GameManager>();
    }
    private void FixedUpdate()
    {
        if (gameManager.gameStarted)
        {
            if (target == null)
                return; //if target not assign it will return and not gonna work.

            transform.rotation = Quaternion.Euler(lookAtRotation, target.rotation.y, transform.rotation.z);
            desiredHeight = target.position.y + followHeight;
            desiredDistance = target.position.z - followDistance;
            desiredX = target.position.x + followX;
            if (Vector3.Distance(transform.position, new Vector3(desiredX, desiredHeight, desiredDistance)) >= lerpClamp)
            {
                transform.position = Vector3.Lerp(transform.position, new Vector3(desiredX, desiredHeight, desiredDistance), smoothness * Time.fixedDeltaTime);
            }
        }
        else
        {
            transform.position = new Vector3(0, 9.5f, -9.5f);
            transform.eulerAngles = new Vector3(15, 0, 0);
        }
    }

}
