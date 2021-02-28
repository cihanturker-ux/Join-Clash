using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
public class GameManager : MonoBehaviour
{

    [HideInInspector] public bool gameStarted = false;
    [HideInInspector] public static bool gameEnded = false;
    [SerializeField] private GameObject gameEndPanel;
    [HideInInspector] public static int coin = 0;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            gameStarted = true;
        }
        if (gameEnded == true)
        {
            coin += 300;
            gameEndPanel.SetActive(true);
            
        }
    }

    public void RestartGame()
    {
        SceneManager.LoadScene(0);
    }
}
