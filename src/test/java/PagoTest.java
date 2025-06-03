import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
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
public class PagoTest {

    static MountableFile war = MountableFile.forHostPath(Paths.get("src/test/resources/PupaSv-1.0-SNAPSHOT.war").toAbsolutePath());
    static Network red = Network.newNetwork();

    @Container
    public static BrowserWebDriverContainer<?> chrome = new BrowserWebDriverContainer<>("selenium/standalone-chrome:125.0").withCapabilities(new ChromeOptions().addArguments("--ignore-certificate-errors")      // Ignora certificados inválidos
            .addArguments("--disable-web-security")             // Desactiva seguridad CORS (¡solo para pruebas!)
            .addArguments("--allow-insecure-localhost")         // Acepta IPs locales como seguras
            .addArguments("--allow-running-insecure-content")).withNetwork(red).withRecordingMode(BrowserWebDriverContainer.VncRecordingMode.RECORD_ALL, new File("target"), VncRecordingContainer.VncRecordingFormat.MP4);

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
    protected WebDriver driver;

    @BeforeAll
    public void inicializar() {
        frontend = new GenericContainer<>("mi-frontend").withExposedPorts(80).withNetwork(red).withEnv("HOST", "backendapp").withEnv("PORT", "9080").withNetworkAliases("frontendapp").dependsOn(servidorDeAplicaion);
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
    public void testSelecionarProducto() throws InterruptedException {
        System.out.println("test comprar");

        driver.get("http://frontendapp:80");
        JavascriptExecutor js = (JavascriptExecutor) driver;
        WebElement navBar = driver.findElement(By.id("nav-bar"));

        WebElement liMenu = (WebElement) js.executeScript("const root = arguments[0].shadowRoot;" + "const items = root.querySelectorAll('#menu-lista li');" + "return Array.from(items).find(el => el.textContent.trim() === 'Menu');", navBar);

        //selecionamos menu
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
        WebElement btnAgregar = (WebElement) js.executeScript("return arguments[0].querySelector('#btnAgregar');", firstCard);

        //selecionamos 2 productos
        btnAgregar.click();
        btnAgregar.click();
        Thread.sleep(1000);

        WebElement cartCard = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let listContainer = root.querySelector('.list-container');" + "let cartLi = listContainer.querySelector('#cartLi');" + "let botonCart = cartLi.querySelector('#boton-menu-cart');" + "let cartCard = botonCart.querySelector('#cartCard');" + "return cartCard;", navBar);

        Thread.sleep(1000);
        //selecionar la opcion de pagar en carrito
        WebElement spanElement = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let listContainer = root.querySelector('.list-container');" + "let cartLi = listContainer.querySelector('#cartLi');" + "let botonCart = cartLi.querySelector('#boton-menu-cart');" + "let cartCardContainer = botonCart.querySelector('.cartCardContainer');" +
                "let targetSpan = cartCardContainer.querySelector('span');" + "return targetSpan;", navBar);
        actions.moveToElement(spanElement).perform();
        Thread.sleep(500);
        WebElement btnPagar = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let listContainer = root.querySelector('.list-container');" + "let btnPagar = listContainer.querySelector('#btnCardPagar');" + "return btnPagar;", cartCard);

        Thread.sleep(1000);
        btnPagar.click();
        Thread.sleep(1000);

        //obtenemos zona pago ZonaPago
        WebElement zonaPago = driver.findElement(By.id("ZonaPago"));
        zonaPago.click();
//        container
        //selecionamos sucursal
        WebElement sucursales = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let container = root.querySelector('.container');" + "let resumen = container.querySelector('.resumen');" + "let info = resumen.querySelector('.info');" + "let select = info.querySelector('select');" + "return select;", zonaPago);
        js.executeScript("arguments[0].selectedIndex = 1;" + "arguments[0].dispatchEvent(new Event('change', { bubbles: true }));", sucursales);
        Thread.sleep(1000);

        WebElement btnPagarOrdenFinal = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let container = root.querySelector('.container');" + "let resumen = container.querySelector('.resumen');" + "let info = resumen.querySelector('.info');" + "let buttons = info.querySelectorAll('button');" + "return Array.from(buttons).find(btn => btn.textContent.trim() === 'Pagar');", zonaPago);
        WebElement volver = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let container = root.querySelector('.container');" + "let resumen = container.querySelector('.resumen');" + "let info = resumen.querySelector('.info');" + "let buttons = info.querySelectorAll('button');" + "return Array.from(buttons).find(btn => btn.textContent.trim() === 'Volver');", zonaPago);
        WebElement btnAGregar = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let container = root.querySelector('.container');" + "let resumen = container.querySelector('.resumen');" + "let info = resumen.querySelector('.info');" + "let buttons = info.querySelectorAll('button');" + "return Array.from(buttons).find(btn => btn.textContent.trim() === 'Agregar pago');", zonaPago);

        js.executeScript("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", btnAGregar);

        Thread.sleep(500); // deja tiempo para animaciones
        btnAGregar.click();

        //selecionar forma de pago
        WebElement formasPago = (WebElement) js.executeScript("let root = arguments[0].shadowRoot;" + "let container = root.querySelector('.container');" + "let resumen = container.querySelector('.resumen');" + "let info = resumen.querySelector('.info');" + "let selects = info.querySelectorAll('select');" + "return selects[1];", zonaPago);

        js.executeScript("arguments[0].selectedIndex = 1;" + "arguments[0].dispatchEvent(new Event('change', { bubbles: true }));", formasPago);

        //
        btnPagarOrdenFinal.click();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
        Alert alert = wait.until(ExpectedConditions.alertIsPresent());
        alert.accept();
        Thread.sleep(5000);
    }
}
