import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testcontainers.containers.*;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.MountableFile;

import java.io.File;
import java.nio.file.Paths;
import java.time.Duration;
import java.util.List;

@Testcontainers
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ProductoTest {
    static MountableFile war = MountableFile.forHostPath(Paths.get("src/test/resources/PupaSv-1.0-SNAPSHOT.war").toAbsolutePath());
    static Network red = Network.newNetwork();

    @Container
    public static BrowserWebDriverContainer<?> chrome = new BrowserWebDriverContainer<>("selenium/standalone-chrome:125.0").withCapabilities(new ChromeOptions().addArguments("--ignore-certificate-errors")      // Ignora certificados inválidos
            .addArguments("--disable-web-security")             // Desactiva seguridad CORS (¡solo para pruebas!)
            .addArguments("--allow-insecure-localhost")         // Acepta IPs locales como seguras
            .addArguments("--allow-running-insecure-content")).withNetwork(red)
                    .withRecordingMode(BrowserWebDriverContainer.VncRecordingMode.RECORD_ALL,
                            new File("target"),
                    VncRecordingContainer.VncRecordingFormat.MP4);

    static String dbName = "Tipicos";
    static String dbPassword = "12345";
    static String dbUser = "postgres";
    static int dbPort = 5432;

    @Container
    static GenericContainer postgres = new PostgreSQLContainer("postgres:16-alpine").withDatabaseName(dbName).withPassword(dbPassword).withUsername(dbUser).withInitScript("tipicos_tpi135_2025.sql").withExposedPorts(dbPort).withNetwork(red).withNetworkAliases("db16_tpi");

    @Container
    static GenericContainer servidorDeAplicaion = new GenericContainer("liberty_app").withCopyFileToContainer(war, "/config/dropins/PupaSv-1.0-SNAPSHOT.war").withExposedPorts(9080).withNetwork(red).withNetworkAliases("backendapp") // << Aquí
            .withEnv("DB_PASSWORD", dbPassword).withEnv("DB_USER", dbUser).withEnv("DB_NAME", dbName).withEnv("DB_PORT", String.valueOf(dbPort)).withEnv("DB_HOST", "db16_tpi").dependsOn(postgres);

    static GenericContainer<?> frontend;
    protected  WebDriver driver;

    @BeforeAll
    public void inicializar() {
        frontend = new GenericContainer<>("fronted-test").withExposedPorts(80).withNetwork(red).withEnv("HOST", "backendapp").withEnv("PORT", "9080").withNetworkAliases("frontendapp").dependsOn(servidorDeAplicaion);
        driver = chrome.getWebDriver();
        frontend.start();
    }
    @AfterAll
    public void tearDown() {
        if (driver != null) {
            driver.quit(); // Cerramos la sesión cuando todos los tests hayan terminado
        }
    }

    @Test
    @Order(1)
    public void testMenuProductosListados() throws InterruptedException {
        System.out.println("test Menu se renderizan card de productos por defecto");

        // 🔥 Clave: usar el hostname especial para apuntar a tu máquina host
        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;
        WebElement navBar = driver.findElement(By.id("nav-bar"));

        WebElement liMenu = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "const items = root.querySelectorAll('#menu-lista li');" + "return Array.from(items).find(el => el.textContent.trim() === 'Menu');", navBar);

        liMenu.click();
        Thread.sleep(1000);
        WebElement productosContainer = driver.findElement(By.id("productos-container"));
        List<WebElement> cards = (List<WebElement>) js.executeScript("const root = arguments[0].shadowRoot;" + "const section = root.querySelector('section');" + "const list = section.querySelector('.list-producto-container');" + "return Array.from(list.querySelectorAll('.card'));", productosContainer);


        String title = driver.getTitle();
        Assertions.assertNotNull(title);
        Assertions.assertFalse(title.isBlank());
        Assertions.assertTrue(cards.size() == 10);
    }

    @Test
    @Order(2)
    public void testMenuOption() throws InterruptedException {
        Thread.sleep(1000);
        System.out.println("test opciones");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;
        WebElement navBar = driver.findElement(By.id("nav-bar"));

        WebElement liMenu = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "const items = root.querySelectorAll('#menu-lista li');" + "return Array.from(items).find(el => el.textContent.trim() === 'Menu');", navBar);

        liMenu.click();
        WebElement articulosContainer = driver.findElement(By.id("productos-container"));

        WebElement select = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "return root.querySelector('.busqueda-container select');", articulosContainer);

        js.executeScript("arguments[0].selectedIndex = 1;" + "arguments[0].dispatchEvent(new Event('change', { bubbles: true }));", select);

        // 👇 Espera a que las cards aparezcan
        wait.until(d -> {
            JavascriptExecutor jse = (JavascriptExecutor) d;
            Object result = jse.executeScript("const root = arguments[0].shadowRoot;" + "const sections = root.querySelectorAll('section');" + "if (!sections[1]) return false;" + "const list = sections[1].querySelector('.list-combo-container');" + "return list && list.querySelectorAll('.card').length > 0;", articulosContainer);
            return result instanceof Boolean && (Boolean) result;
        });

        List<WebElement> cards = (List<WebElement>) js.executeScript(
                "const root = arguments[0].shadowRoot;" + "const sections = root.querySelectorAll('section');"
                        + "const list = sections[1].querySelector('.list-combo-container');" +
                        "return Array.from(list.querySelectorAll('.card'));", articulosContainer);

        WebElement titulo = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "const sections = root.querySelectorAll('section');" + "const list = sections[1];" + "return list.querySelector('h1');", articulosContainer);

        Assertions.assertEquals("Combos", titulo.getText());
        Assertions.assertEquals(10, cards.size());

    }

    @Test
    @Order(3)
    public void testMenuBusquedaNombreProdcutos() throws InterruptedException {
        Thread.sleep(1000);
        System.out.println("test BusquedaNombreProductos");
        String nombre = "cafe";
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;

        // Obtener el nav-bar y hacer clic en la opción "Menu"
        WebElement navBar = driver.findElement(By.id("nav-bar"));
        WebElement liMenu = (WebElement) js.executeScript(
                "const root = arguments[0].shadowRoot;" +
                        "const items = root.querySelectorAll('#menu-lista li');" +
                        "return Array.from(items).find(el => el.textContent.trim() === 'Menu');",
                navBar
        );
        liMenu.click();

        // Obtener el contenedor de productos
        WebElement articulosContainer = driver.findElement(By.id("productos-container"));

        // Esperar hasta que el <input> dentro de .busqueda-container esté disponible
        WebElement input = wait.until(driver1 -> {
            Object result = js.executeScript(
                    "const root = arguments[0].shadowRoot;" +
                            "return root && root.querySelector('.busqueda-container input');",
                    articulosContainer
            );
            return (WebElement) result;
        });


        // Establecer el valor del input y disparar eventos necesarios
        js.executeScript(
                "arguments[0].value = arguments[1];" +
                        "arguments[0].dispatchEvent(new Event('input', { bubbles: true }));" +
                        "arguments[0].dispatchEvent(new KeyboardEvent('keydown',  {key: 'Enter', code: 'Enter',which: 13,keyCode: 13,}));",
                input, nombre
        );

        Thread.sleep(3000);
        // Esperar hasta que el <input> dentro de .busqueda-container esté disponible
        List<WebElement> cards = wait.until(driver1 -> {
            Object result = js.executeScript("const root = arguments[0].shadowRoot;" +
                    "const section = root.querySelector('section');" +
                    "const list = section.querySelector('.list-producto-container');"
                    + "return Array.from(list.querySelectorAll('.card'));", articulosContainer
            );
            return (List<WebElement>) result;
        });
        Assertions.assertTrue(cards.get(0).getText().contains(nombre));
    }

    @Test
    @Order(4)
    public void testMenuBusquedaNombreCombo() throws InterruptedException {
        System.out.println("test Menu se renderizan card de productos por defecto");
        String nombre = "cafe";
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;

        // Obtener el nav-bar y hacer clic en la opción "Menu"
        WebElement navBar = driver.findElement(By.id("nav-bar"));
        WebElement liMenu = (WebElement) js.executeScript(
                "const root = arguments[0].shadowRoot;" +
                        "const items = root.querySelectorAll('#menu-lista li');" +
                        "return Array.from(items).find(el => el.textContent.trim() === 'Menu');",
                navBar
        );
        liMenu.click();

        // Obtener el contenedor de productos
        WebElement articulosContainer = driver.findElement(By.id("productos-container"));

        //selecionamos combos
        WebElement select = wait.until(driver1 -> {
            Object element = js.executeScript(
                    "const root = arguments[0].shadowRoot;" +
                            "return root ? root.querySelector('.busqueda-container select') : null;",
                    articulosContainer
            );
            return element instanceof WebElement ? (WebElement) element : null;
        });
        js.executeScript(
                "arguments[0].selectedIndex = 1;" +
                        "arguments[0].dispatchEvent(new Event('change', { bubbles: true }));",
                select
        );
        Thread.sleep(1000);

        // Esperar hasta que el <input> dentro de .busqueda-container esté disponible
        WebElement input = wait.until(driver1 -> {
            Object result = js.executeScript(
                    "const root = arguments[0].shadowRoot;" +
                            "return root && root.querySelector('.busqueda-container input');",
                    articulosContainer
            );
            return (WebElement) result;
        });

        // Establecer el valor del input y disparar eventos necesarios
        js.executeScript(
                "arguments[0].value = arguments[1];" +
                        "arguments[0].dispatchEvent(new Event('input', { bubbles: true }));" +
                        "arguments[0].dispatchEvent(new KeyboardEvent('keydown',  {key: 'Enter', code: 'Enter',which: 13,keyCode: 13,}));",
                input, nombre
        );

        Thread.sleep(3000);
        // Esperar hasta que el <input> dentro de .busqueda-container esté disponible
        List<WebElement> cards = wait.until(driver1 -> {
            Object result = js.executeScript(
                    "const root = arguments[0].shadowRoot;" + "const sections = root.querySelectorAll('section');"
                            + "const list = sections[1].querySelector('.list-combo-container');" +
                            "return Array.from(list.querySelectorAll('.card'));", articulosContainer);
            return (List<WebElement>) result;
        });
        Assertions.assertTrue(cards.size()==4);
    }

    @Test
    @Order(5)
    public void testSelecionarProducto() throws InterruptedException {
        System.out.println("test SelceionarProducto");

        // 🔥 Clave: usar el hostname especial para apuntar a tu máquina host
        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;
        WebElement navBar = driver.findElement(By.id("nav-bar"));

        WebElement liMenu = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "const items = root.querySelectorAll('#menu-lista li');" + "return Array.from(items).find(el => el.textContent.trim() === 'Menu');", navBar);

        liMenu.click();
        Thread.sleep(1000);
        WebElement productosContainer = driver.findElement(By.id("productos-container"));
        List<WebElement> cards = (List<WebElement>) js.executeScript("const root = arguments[0].shadowRoot;" + "const section = root.querySelector('section');" + "const list = section.querySelector('.list-producto-container');" + "return Array.from(list.querySelectorAll('.card'));", productosContainer);

        // Tomar la primera card
        WebElement firstCard = cards.get(0);

        // Hacer hover sobre la card usando Actions
        Actions actions = new Actions(driver);
        actions.moveToElement(firstCard).perform();
        Thread.sleep(500);

        // Obtener el botón con ID "btnAgregar" dentro de la card usando JS
        WebElement btnAgregar = (WebElement) js.executeScript(
                "return arguments[0].querySelector('#btnAgregar');",
                firstCard
        );

        btnAgregar.click();
        btnAgregar.click();
        Thread.sleep(1000);


        WebElement spanElement = (WebElement) js.executeScript(
                "let root = arguments[0].shadowRoot;" +
                        "let listContainer = root.querySelector('.list-container');" +
                        "let cartLi = listContainer.querySelector('#cartLi');" +
                        "let botonCart = cartLi.querySelector('#boton-menu-cart');" +
                        "let cartCardContainer = botonCart.querySelector('.cartCardContainer');" +
                        // Reemplaza '#contador' por el ID real del span que deseas obtener
                        "let targetSpan = cartCardContainer.querySelector('span');" +
                        "return targetSpan;",
                navBar
        );

        Assertions.assertNotNull(spanElement);
        Assertions.assertNotNull(spanElement.getText().contains("2"));
    }


}



