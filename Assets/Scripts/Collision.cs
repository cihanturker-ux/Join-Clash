using UnityEngine;

public class Collision : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            other.transform.parent = null;
            Destroy(other.gameObject);
            //patlama efekti
        }
    }
}
