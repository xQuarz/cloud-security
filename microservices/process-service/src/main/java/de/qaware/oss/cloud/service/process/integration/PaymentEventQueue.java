package de.qaware.oss.cloud.service.process.integration;

import javax.annotation.Resource;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.jms.*;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonWriter;
import java.io.StringWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

@Stateless
public class PaymentEventQueue {

    @Inject
    private Logger logger;

    @Resource(lookup = "jms/activeMqConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/PaymentEvents")
    private Queue paymentQueue;

    public void publish(String eventType, JsonObject paymentEvent) {
        try (Connection connection = connectionFactory.createConnection()) {
            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            MessageProducer producer = session.createProducer(paymentQueue);

            StringWriter payload = new StringWriter();
            JsonWriter jsonWriter = Json.createWriter(payload);
            jsonWriter.writeObject(paymentEvent);

            TextMessage textMessage = session.createTextMessage(payload.toString());
            textMessage.setJMSType(eventType);
            textMessage.setStringProperty("contentType", "application/vnd.payment.v1+json");

            producer.send(textMessage);
            logger.log(Level.INFO, "Sent {0} to BillingEvents queue.", textMessage);
        } catch (JMSException e) {
            logger.log(Level.WARNING, "Could not send JMS message.", e);
        }
    }
}
